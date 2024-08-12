
# Need to be abl to categorise by location 
CH$Nearest_City

# Step 2: Create a vector of city names  
cities <- c("Belfast", "Birmingham", "Brighton", "Bristol", "Cardiff", "Edinburgh", "Glasgow", "Leeds", "Liverpool", "London", "Manchester", "Newcastle", "Norwich", "Nottingham", "Plymouth", "Sheffield", "Southampton")  

# Step 3: Map the numerical values to the city names  
Locations <- factor(CH$Nearest_City, levels = 1:17, labels = cities)  

sum(summary(Locations)) # this counts the locaitons 
# Save a new location as a column rather than numbers - then can gorup by this column 


df <- CH_data %>%  group_by(Segment, Q14.a.1, Q14.a.2)  %>% summarise(Count = n())
df
