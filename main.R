# install.packages("googlesheets")
# install.packages("gridExtra")
# install.packages("grid")
# install.packages("gridExtra")

library(googlesheets)
library(gridExtra)
library(grid)
library(gridExtra)

rm(list = ls()) # Clear memory  
gs_auth() # Authotorize access to Google Sheets - follow instructions in Console  

#setwd("~/Dropbox/Documents/FriendCash/FriendCash_R")# Set working directory 
gs_object = gs_url("https://docs.google.com/spreadsheets/d/1z83QclczZO4nEwcJql_LQEH4-ow83vBNld5w8cIi4Y4/edit") # Set Google Sheet
DF <- gs_read(gs_object, ws = "Sheet1") # Set sheet in Google Sheet

DF = as.data.frame(DF)
DF = DF[,-c(3,4,5)]
DF[,1] = gsub(" ","_",DF[,1],fixed = TRUE) # Remove all spaces
colnames(DF) = gsub(" ","_",colnames(DF),fixed = TRUE) # Remove all spaces 
colnames(DF) = tolower(colnames(DF)) # set all letters in collumn names to uppercase
colnames(DF) = c("Name","ExpenceAmount",names(DF[3:dim(DF)[2]]))
DF$Name = tolower(DF$Name) # set all letters in collumn names to uppercase
DF$Name = gsub(" ","_", DF$Name, fixed=TRUE) 

DF$PeopleInExpence = 0. # New numeric collumn

# Set relevant collumns to numeric. 
for (i in 2:dim(DF)[2]){ 
    DF[,i] <- as.numeric(DF[,i])  
}
for (i in 1:dim(DF)[1]){
  DF$PeopleInExpence[i] = sum(as.numeric(DF[i,3:dim(DF)[2]]))
}

DF$PricePerPersonExpence = 0.
DF$PricePerPersonExpence = as.numeric(as.numeric(DF$ExpenceAmount)/as.numeric(DF$PeopleInExpence))

DF_ExpencesTable = DF
dimx = dim(DF_ExpencesTable)[2]
DF_ExpencesTable[,3:(dimx-2)] = DF[,3:(dimx-2)]*DF$PricePerPersonExpence

DF_ExpencesTable = DF_ExpencesTable[,-c(1, 2,dimx-1,dimx)]
DF_ExpencesTable = colSums(-DF_ExpencesTable)
DF_ExpencesTable = as.data.frame(DF_ExpencesTable)
colnames(DF_ExpencesTable) = c("Expences")

DF_OutlayerTable = DF[,1:2]
table(DF_OutlayerTable)
tapply(DF_OutlayerTable$ExpenceAmount, DF_OutlayerTable$Name)
DF_OutlayerTable = data.frame(tapply(DF_OutlayerTable$ExpenceAmount, DF_OutlayerTable$Name, FUN=sum))
colnames(DF_OutlayerTable) = c("Outlayes")

DF_OverviewTable = DF_ExpencesTable
DF_OverviewTable$Names = rownames(DF_ExpencesTable)
DF_OutlayerTable$Names = rownames(DF_OutlayerTable)

DF_OverviewTable = merge(DF_OverviewTable, DF_OutlayerTable, by="Names", all.x=TRUE, all.y=TRUE)
DF_OverviewTable[is.na(DF_OverviewTable)] = 0

DF_OverviewTable$Balance = DF_OverviewTable$Expences + DF_OverviewTable$Outlayes
DF_OverviewTable = (data.frame(DF_OverviewTable))


DF_PayTable = DF_OverviewTable
maxiter = 10000;
DF_PayTable = matrix(0, nrow=maxiter, ncol = 3);

DF_OverviewTableIterations = DF_OverviewTable;

for (i in 1:maxiter){
maxpers = unname(which(DF_OverviewTableIterations$Balance == max(DF_OverviewTableIterations$Balance))[1])
minpers = unname(which(DF_OverviewTableIterations$Balance == min(DF_OverviewTableIterations$Balance))[1])
minpers_vec = unname(which(DF_OverviewTableIterations$Balance == min(DF_OverviewTableIterations$Balance)))

if (length(minpers_vec) > 1 && sum(abs(DF_OverviewTableIterations$Balance))<1e-5){
  cat("The for loop was stopped in iteration ", i)
  break }

DF_PayTable[i,] = matrix(c(unname(DF_OverviewTableIterations[minpers,1]) , unname(DF_OverviewTableIterations[maxpers,1]), unname(DF_OverviewTableIterations[minpers,4])))
  
  DF_OverviewTableIterations[maxpers,4] = DF_OverviewTableIterations[maxpers,4] - abs(DF_OverviewTableIterations[minpers,4])
  DF_OverviewTableIterations[minpers,4] = DF_OverviewTableIterations[minpers,4] + abs(DF_OverviewTableIterations[minpers,4])
    }

if (i == maxiter) {print("ERROR! Result not correct. Please increase variable maxiter"); }

dimy = min(which(DF_PayTable[,1]==0))-1
DF_PayTable = DF_PayTable[1:dimy,]
DF_PayTable = data.frame(DF_PayTable)
View(DF_PayTable)
colnames(DF_PayTable) = c("Sends", "Receives", "ThisAmount")
View(DF_PayTable)
DF_OverviewTable$Expences = round(DF_OverviewTable$Expences,2)
DF_OverviewTable$Outlayes = round(DF_OverviewTable$Outlayes,2)
DF_OverviewTable$Balance = round(DF_OverviewTable$Balance,2)

DF_PayTable[,3] = abs(round(as.numeric(as.character(DF_PayTable[,3])),2))

cat("Total amount of money transfered", sum(sum(DF_PayTable[,3])))
cat("Total amount of expences", sum(DF_OverviewTable$Outlayes))
cat("Total amount of outlayes", sum(DF_OverviewTable$Expences))
DF_PayTable
DF_OverviewTable
 
 


max.print <- getOption('max.print')
options(max.print = nrow(DF_OverviewTable) * ncol(DF_OverviewTable) * nrow(DF_PayTable) * ncol(DF_PayTable))
sink('DF_OverviewTable.txt')
cat(noquote(("============================================")),"\n")
cat(noquote(("EXPENCES, OUTLAYES AND BALANCE TABLE")),"\n")
cat(noquote(("============================================")),"\n")
print(DF_OverviewTable, row.names = FALSE)
cat(noquote(("============================================")),"\n\n\n")


cat(noquote(("============================================")),"\n")
cat(noquote(("TRANSFER/PAY TABLE - WHO OWS WHO MONEY")),"\n")
cat(noquote(("============================================")),"\n")
print(DF_PayTable, row.names = FALSE)
cat(noquote(("============================================")),"\n\n\n")


cat(noquote(("============================================")),"\n")
cat("Total amount of money transfered", sum(sum(DF_PayTable[,3])),"\n")
cat("Total amount of expences", sum(DF_OverviewTable$Outlayes),"\n")
cat("Total amount of outlayes", sum(DF_OverviewTable$Expences),"\n")
cat("Differences between total amount of expences  \n")
cat("and outlayes may occur due to round of errors  \n")
cat(noquote(("============================================")),"\n")
sink()
options(max.print=max.print)

