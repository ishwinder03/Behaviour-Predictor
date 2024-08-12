install.packages("ggplot2")
library("tidyverse")
library("ggplot2")

# Create the bar chart - Gender per segment  

# Calculate counts  
counts <- CH_data %>%  
  group_by(Segment, D1_Gender) %>%  
  summarise(Count = n()) %>%  
  ungroup()  
  
# Count is an object that we have definied at n()
# Create the bar chart  
ggplot(counts, aes(x = interaction(Segment, D1_Gender, lex.order = TRUE), y = Count, fill = factor(D1_Gender))) +  
  geom_bar(stat = "identity", position = position_dodge()) +  
  labs(title = "Bar Chart by Segment and Subcategory",  
       x = "Segment and Subcategory",  
       y = "Value",  
       fill = "Subcategory") +  
  scale_fill_manual(values = c("1" = "blue", "2" = "green")) +  
  theme_minimal() +  
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  


## I DONT KNOW WHICH REFERES TO WHICH. 

# No. of kids in each age gropu per segment - this means nothing  
summary_table <- CH_data %>%    
  group_by(Segment) %>%    
  summarise(  
    Expecting = sum(D6_Children.c.1 == "1", na.rm = TRUE),  
    `0 to 3` = sum(D6_Children.c.2 == "2", na.rm = TRUE),  
    `4 to 6` = sum(D6_Children.c.3 == "3", na.rm = TRUE),  
    `7 to 10` = sum(D6_Children.c.4 == "4", na.rm = TRUE),  
    `11 to 13` = sum(D6_Children.c.5 == "5", na.rm = TRUE),  
    `14 to 15` = sum(D6_Children.c.6 == "6", na.rm = TRUE),  
    `16 to 17` = sum(D6_Children.c.7 == "7", na.rm = TRUE),  
    `18+` = sum(D6_Children.c.8 == "8", na.rm = TRUE),  
    None = sum(D6_Children.c.9 == "9", na.rm = TRUE)  
  )  

# View the summary table  
print(summary_table)  

##### Private health insurance for your family vs segment 
prv <- CH_data %>% group_by(Segment, Q9.a.2) %>% summarise(Count = n()) %>%  
  ungroup() 
prv
prv1 <- prv %>% group_by(Segment) %>%  summarise(Sum = sum(Count))
prv1

ggplot(prv, aes(x = interaction(Segment, Q9.a.2, lex.order = TRUE), y = Percentage, fill = factor(Q9.a.2))) +  
  geom_bar(stat = "identity", position = position_dodge()) +  
  labs(title = "Bar Chart by Segment and Subcategory",  
       x = "Segment and Subcategory",  
       y = "Value",  
       fill = "Subcategory") +  
  scale_fill_manual(values = c("1" = "blue", "2" = "green","3" = "grey")) +  
  theme_minimal() +  
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  


# do the sum of the weightings *the count 
colnames(CH_data)
