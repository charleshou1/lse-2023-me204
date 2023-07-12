### PART 1: SETUP ###

library(tidyverse)
library(xml2) 
df <- read_csv("/Users/charl/Documents/Harvard/LSE/R/Dec_lsoa_grocery.csv")

### PART 2: WORKING WITH XML ###
selected_cols <- c("area_id", "fat", "saturate", "salt", "protein", "sugar", 
                   "carb", "fibre", "alcohol")

df[selected_cols]
row1 <- df %>% slice(1)

tesco_data_xml <- xml_new_root("data", .encoding = "UTF-8")
tesco_data_xml

temp <- xml_new_root("data")
temp

area_node <- xml_new_root("area", area_id = row1 %>% pull(area_id))

for(nutrient_name in selected_cols[-1]){
  xml_add_child(area_node, nutrient_name, row1 %>% pull(nutrient_name))
}

area_node

### add area node as a child to root ###
xml_add_child(tesco_data_xml, area_node)

### saving the file ###
write_xml(tesco_data_xml, "sample_tesco_data.xml")

###get area node function ###
get_area_node <- function(row){
  row <- data.frame(row)
  area_node <- xml_new_root("area", area_id = row %>% pull(area_id))
  
  # create nutrients node 
  nutrients_node <- xml2::xml_add_child(area_node, "nutrients")
  
  for(nutrient_name in selected_cols[-1]){
    xml_add_child(nutrients_node, nutrient_name, row %>% pull(nutrient_name))
  }
  return(area_node)
}

### part 3 ###
tesco_data_xml2 <- xml_new_root("data", .encoding = "UTF-8")
for (i in 1:10)
{
  tesco_data_xml2 %>% xml_add_child(get_area_node(df[i, ]))
}

write_xml(tesco_data_xml2, "sample_tesco_data2.xml")


