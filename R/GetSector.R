#' A Function to Return DC Sector (i.e. overall Public and 
#' Public Charter Schools) Level Education Data
#'
#' @description This function retrieves the data from the exhibits on 
#' LearnDC.org's Sector Report Cards and Profiles.
#' @param exhibit character, exhibit name.  one of 
#' c("graduation","dccas","hqt_classes","staff_degree","mgp_scores",
#' "special_ed","enrollment")
#' @usage GetSector("exhibit")
#'
#' @references \url{http://learndc.org/schoolprofiles/view?s=lea-0000#reportcard}
#' \url{http://learndc.org/schoolprofiles/view?s=lea-0001#reportcard}
#' @author Benjamin Robinson, \email{benj.robinson2@gmail.com}
#' 
#' @return data frame
#' @export
#'
#' @examples
#' sector_grad <- GetSector("graduation")

GetSector <- function(exhibit){
  exhibit <- tolower(exhibit)
  if(exhibit %notin% c("graduation","dccas","hqt_classes","staff_degree","mgp_scores","special_ed","enrollment","parcc")){
    stop("The requested exhibit does not exist.\r
    Please check the spelling of your exhibit using GetExhibits('sector') to get the correct names of LearnDC's Sector Exhibits.")
  } else {
 if(exhibit %in% "parcc"){
 sector <- subset(sector_parcc,
 subject %in% c("Math","Reading") &
 grade %notin% c('Algebra I','English I','English II','Geometry') &
 cohort=='Official' &
 !is.na(percent_level_1) & !is.na(percent_level_2) & !is.na(percent_level_3) &
 !is.na(percent_level_4) & !is.na(percent_level_5),-c(school_name,cohort,assessment))
 names(sector)[1:3] <- c('org_code','org_name','org_type')
 sector$org_type <- "Sector"
 names(sector)[15] <- "percent_proficient_3+"
 return(unique(sector[c(3,1,2,4:ncol(sector))]))
  } else { 
 sector <- read.csv(text = RCurl::getURL(paste0("https://learndc-api.herokuapp.com//api/exhibit/",exhibit,".csv?s[][org_type]=lea&s[][org_code]=0001&s[][org_code]=0000&&s[][org_code]=6000&sha=promoted")),stringsAsFactors=F)
 sector$org_code <- sapply(sector$org_code,leadgr,4)
 sector$org_type <- gsub("(^|[[:space:]])([[:alpha:]])","\\1\\U\\2",sector$org_type,perl=TRUE)
 sector_overview <- subset(jsonlite::fromJSON("https://learndc-api.herokuapp.com//api/leas?sha=promoted")[2:3],org_code %in% sector$org_code)
 sector <- merge(sector,sector_overview,by=c('org_code'),all.x=TRUE)
 sector$org_type <- "Sector"

 if(any(names(sector) %in% 'subgroup')){
    sector$subgroup <- tolower(sector$subgroup)
    subgroup_map <- c("bl7"="Black/African American",
                      "wh7"="White",
                      "hi7"="Hispanic",
                      "as7"="Asian",
                      "mu7"="Multiracial",
                      "pi7"="Pacific Islander",
                      "am7"="American Indian",
                      "direct cert"="TANF/SNAP eligible",
                      "economy"="Economically Disadvantaged",
                      "lep"="English Learner",
                      "sped"="Special Education",
                      "sped level 1"="Special Education Level 1",
                      "sped level 2"="Special Education Level 2",
                      "sped level 3"="Special Education Level 3",
                      "sped level 4"="Special Education Level 4",
                      "all sped students"="Special Education",
                      "alt test takers"="Alternative Testing",
                      "with accommodations"="Testing Accommodations",
                      "all"="All",
                      "female"="Female",
                      "male"="Male",
                      "asian"="Asian",
                      "economically disadvantaged"="Economically Disadvantaged",
                      "african american"="Black/African American",
                      "english learner"="English Learner",
                      "hispanic"="Hispanic",
                      "multiracial"="Multiracial",
                      "pacific islander"="Pacific Islander",
                      "special education"="Special Education",
                      "white"="White")
    sector$subgroup <- subgroup_map[sector$subgroup]
    }

    if(any(names(sector) %in% 'subject')){
        sector$subject <- gsub("(^|[[:space:]])([[:alpha:]])","\\1\\U\\2",sector$subject,perl=TRUE)
    }

    if(any(names(sector) %in% 'grade')){
        grade_map <- c('all'='All',
                      'grade 12'='12th Grade',
                      'grade 11'='11th Grade',
                      'grade 10'='10th Grade',
                      'grade 9'='9th Grade',
                      'grade 8'='8th Grade',
                      'grade 7'='7th Grade',
                      'grade 6'='6th Grade',
                      'grade 5'='5th Grade',
                      'grade 4'='4th Grade',
                      'grade 3'='3rd Grade',
                      'grade 2'='2nd Grade',
                      'grade 1'='1st Grade',
                      'grade ao'='Adult',
                      'un'='Ungraded',
                      'kg'='Kindergarten',
                      'pk3'='Pre-Kindergarten for 3 Year Olds',
                      'pk4'='Pre-Kindergarten for 4 Year Olds')
        sector$grade <- grade_map[sector$grade]
    }
        
    if(exhibit %in% c('hqt_classes','staff_degree')){
        cat_map <- c("SEC"="Secondary Schools",
                            "ELEM"="Elementary Schools",
                            "MIDDLE"="Middle Poverty Quartiles Schools",
                            "HIGH"="High Poverty Quartile Schools",
                            "LOW"="Low Poverty Quartile Schools",
                            "All"="All Schools")
        sector[[4]] <- cat_map[sector[[4]]]
    }

    if(exhibit %in% c('enrollment')){
        sector$year <- paste0(sector$year,"-",sector$year+1)
    } else {
        sector$year <- paste0(sector$year-1,"-",sector$year)
      }
    }
  sector$population <- NULL
  return(sector[c(2,1,ncol(sector),3:(ncol(sector)-1))])
  }
}