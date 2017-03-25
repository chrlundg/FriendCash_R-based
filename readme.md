# Introduction

**FriendCash\_R-based** is a simple R-based program which can be used to settle expenses and outlays within a group of e.g. fiends. There exists several similar softwares but FriendCash\_R-based may have some advantages compared to the smartphone applications, such as WeShare, Tricount, FriendCash, among many more:

1. It provides an offline version as it is based on Google Sheets.
2. It is easy and free to use and install.
3. It has MUCH better scalability for large groups (5+ person). Very large group (+50 people) and many outlay (+1000) are easy to command from the Google Sheet.
4. Everyone can access the Google Sheet an hereby add outlays and expenses to the report.
5. Choose between two payment methods: Minimum number of transactions (not implemented yet) or minimum amount of transferred money (default option).

# Installation

1. Make a copy of this Google Sheet [1] which you can edit to keep track of the expenses. The sheet should be self-explanatory. More people can be added by adding additional columns between column F and I.
2. Download and install R Project (Linux, Mac, Windows):  [https://r-project.en.softonic.com/](https://r-project.en.softonic.com/)
3. Download and install R Studio (Linux, Mac, Windows):  [https://www.rstudio.com/products/rstudio/download/](https://www.rstudio.com/products/rstudio/download/)
4. Open file &quot;main.R&quot; in R Studio
5. First time you run the program, run line 1-4 to install relevant R packages (choose the line and press cmd+ENTER or ctrl+ENTER).
6. Set correct working directory in line 14
7. Copy the relevant Google Sheet URL into line 15
8. Change name of the relevant sheet in line 16
9. Run everything by pressing cmd+A and cmd+ENTER (Mac, Linux) and ctrl+A and ctrl+ENTER (Windows)
10. Follow the instructions in the Console in R Studio (authotirize gs() to access your Google Sheets)
11. The results are printed to the text file &quot;DF\_OverviewTable.txt&quot; in the working directory

# Other

For questions, comments and suggestions, please contact  [chrlundg@gmail.com](mailto:chrlundg@gmail.com).

20-marts 2017

[1]  [https://docs.google.com/spreadsheets/d/1-5JmCRVht2YKNyiKfEH4bG59DbDZug1QKIwB27CucWU/edit?usp=sharing](https://docs.google.com/spreadsheets/d/1-5JmCRVht2YKNyiKfEH4bG59DbDZug1QKIwB27CucWU/edit?usp=sharing)

# Screen shots

#
![alt tag](https://github.com/chrlundg/FriendCash_R-based/blob/master/screenshot.png)