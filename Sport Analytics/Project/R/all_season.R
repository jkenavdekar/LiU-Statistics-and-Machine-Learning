library(dplyr)

data1 <- read.csv("LHC2017-18-regular/playsequence-20170916-SHL-LHCvsFBK-20172018-qTJ-3n1r1ai6p.csv")
data2 <- read.csv("LHC2017-18-regular/playsequence-20170921-SHL-VLHvsLHC-20172018-qTJ-3n1vE4vA0.csv")
data3 <- read.csv("LHC2017-18-regular/playsequence-20170923-SHL-LHCvsHV71-20172018-qTJ-3n1w3mGHB.csv")
data4 <- read.csv("LHC2017-18-regular/playsequence-20170926-SHL-LHFvsLHC-20172018-qTJ-3n1xV5d3o.csv")
data5 <- read.csv("LHC2017-18-regular/playsequence-20170928-SHL-LHCvsKHK-20172018-qTJ-3n1ykLBnK.csv")
data6 <- read.csv("LHC2017-18-regular/playsequence-20170930-SHL-LHCvsLHF-20172018-qTJ-3n1zrbVVC.csv")
data7 <- read.csv("LHC2017-18-regular/playsequence-20171006-SHL-OHKvsLHC-20172018-qTJ-3n22E7BIo.csv")
data8 <- read.csv("LHC2017-18-regular/playsequence-20171007-SHL-LHCvsOHK-20172018-qTJ-3n22tBbSc.csv")
data9 <- read.csv("LHC2017-18-regular/playsequence-20171012-SHL-MIFvsLHC-20172018-qTJ-3n24wQBuE.csv")
data10 <- read.csv("LHC2017-18-regular/playsequence-20171014-SHL-FHCvsLHC-20172018-qTJ-3n25J8eeL.csv")
data11 <- read.csv("LHC2017-18-regular/playsequence-20171017-SHL-DIFvsLHC-20172018-qTJ-3n2678NqF.csv")
data12 <- read.csv("LHC2017-18-regular/playsequence-20171019-SHL-LHCvsSAIK-20172018-qTJ-3n27FR21h.csv")
data13 <- read.csv("LHC2017-18-regular/playsequence-20171024-SHL-LHCvsRBK-20172018-qTJ-3n2915GFXI.csv")
data14 <- read.csv("LHC2017-18-regular/playsequence-20171026-SHL-RBKvsLHC-20172018-qTJ-3n2Cr5DQG.csv")
data15 <- read.csv("LHC2017-18-regular/playsequence-20171028-SHL-LHCvsFHC-20172018-qTJ-3n2DtPQNC.csv")
data16 <- read.csv("LHC2017-18-regular/playsequence-20171102-SHL-BIFvsLHC-20172018-qTJ-3n2EoIKaw.csv")
data17 <- read.csv("LHC2017-18-regular/playsequence-20171105-SHL-KHKvsLHC-20172018-qTJ-3n2HxIijs.csv")
data18 <- read.csv("LHC2017-18-regular/playsequence-20171114-SHL-LHCvsMIF-20172018-qTJ-3n2I10d0qO.csv")
data19 <- read.csv("LHC2017-18-regular/playsequence-20171116-SHL-HV71vsLHC-20172018-qTJ-3n2KU3I2h.csv")
data20 <- read.csv("LHC2017-18-regular/playsequence-20171117-SHL-LHCvsHV71-20172018-qTJ-3n2KHuIfI.csv")
data21 <- read.csv("LHC2017-18-regular/playsequence-20171121-SHL-BIFvsLHC-20172018-qTJ-3n2MTg64b.csv")
data22 <- read.csv("LHC2017-18-regular/playsequence-20171123-SHL-MIKvsLHC-20172018-qTJ-3n2NjzwQv.csv")
data23 <- read.csv("LHC2017-18-regular/playsequence-20171125-SHL-LHCvsFHC-20172018-qTJ-3n2Pt9sB4.csv")
data24 <- read.csv("LHC2017-18-regular/playsequence-20171130-SHL-SAIKvsLHC-20172018-.csv")
data25 <- read.csv("LHC2017-18-regular/playsequence-20171202-SHL-LHCvsLHF-20172018-.csv")
data26 <- read.csv("LHC2017-18-regular/playsequence-20171207-SHL-LHCvsDIF-20172018-.csv")
data27 <- read.csv("LHC2017-18-regular/playsequence-20171209-SHL-FBKvsLHC-20172018-.csv")
data28 <- read.csv("LHC2017-18-regular/playsequence-20171219-SHL-FHCvsLHC-20172018-.csv")
data29 <- read.csv("LHC2017-18-regular/playsequence-20171226-SHL-LHCvsRBK-20172018-.csv")
data30 <- read.csv("LHC2017-18-regular/playsequence-20171228-SHL-DIFvsLHC-20172018-.csv")
data31 <- read.csv("LHC2017-18-regular/playsequence-20171230-SHL-KHKvsLHC-20172018-.csv")
data32 <- read.csv("LHC2017-18-regular/playsequence-20180104-SHL-LHCvsMIF-20172018-.csv")
data33 <- read.csv("LHC2017-18-regular/playsequence-20180106-SHL-LHCvsSAIK-20172018-.csv")
data34 <- read.csv("LHC2017-18-regular/playsequence-20180111-SHL-MIKvsLHC-20172018-.csv")
data35 <- read.csv("LHC2017-18-regular/playsequence-20180113-SHL-LHCvsMIK-20172018-.csv")
data36 <- read.csv("LHC2017-18-regular/playsequence-20180118-SHL-LHCvsOHK-20172018-.csv")
data37 <- read.csv("LHC2017-18-regular/playsequence-20180120-SHL-LHCvsVLH-20172018-.csv")
data38 <- read.csv("LHC2017-18-regular/playsequence-20180123-SHL-OHKvsLHC-20172018-.csv")
data39 <- read.csv("LHC2017-18-regular/playsequence-20180125-SHL-LHCvsBIF-20172018-.csv")
data40 <- read.csv("LHC2017-18-regular/playsequence-20180127-SHL-LHFvsLHC-20172018-.csv")
data41 <- read.csv("LHC2017-18-regular/playsequence-20180130-SHL-LHCvsKHK-20172018-.csv")
data42 <- read.csv("LHC2017-18-regular/playsequence-20180201-SHL-SAIKvsLHC-20172018-.csv")
data43 <- read.csv("LHC2017-18-regular/playsequence-20180203-SHL-HV71vsLHC-20172018-.csv")
data44 <- read.csv("LHC2017-18-regular/playsequence-20180208-SHL-LHCvsFBK-20172018-.csv")
data45 <- read.csv("LHC2017-18-regular/playsequence-20180210-SHL-MIFvsLHC-20172018-.csv")
data46 <- read.csv("LHC2017-18-regular/playsequence-20180224-SHL-LHCvsDIF-20172018-.csv")
data47 <- read.csv("LHC2017-18-regular/playsequence-20180228-SHL-LHCvsMIK-20172018-.csv")
data48 <- read.csv("LHC2017-18-regular/playsequence-20180301-SHL-FBKvsLHC-20172018-.csv")
data49 <- read.csv("LHC2017-18-regular/playsequence-20180303-SHL-LHCvsVLH-20172018-.csv")
data50 <- read.csv("LHC2017-18-regular/playsequence-20180306-SHL-RBKvsLHC-20172018-.csv")
data51 <- read.csv("LHC2017-18-regular/playsequence-20180308-SHL-LHCvsBIF-20172018-.csv")
data52 <- read.csv("LHC2017-18-regular/playsequence-20180310-SHL-VLHvsLHC-20172018-.csv")

data53 <- read.csv("LHC2017-18-playoffs/playsequence-20180312-SHL-LHCvsHV71-20172018-qUs-8D5Oyf92X.csv")
data54 <- read.csv("LHC2017-18-playoffs/playsequence-20180314-SHL-HV71vsLHC-20172018-qUs-8D5OBo6E5.csv")
data55 <- read.csv("LHC2017-18-playoffs/playsequence-20180318-SHL-LHCvsDIF-20172018-qUs-8D5P7SvM6.csv")
data56 <- read.csv("LHC2017-18-playoffs/playsequence-20180320-SHL-DIFvsLHC-20172018-.csv")
data57 <- read.csv("LHC2017-18-playoffs/playsequence-20180322-SHL-LHCvsDIF-20172018-.csv")
data58 <- read.csv("LHC2017-18-playoffs/playsequence-20180324-SHL-DIFvsLHC-20172018-.csv")
data59 <- read.csv("LHC2017-18-playoffs/playsequence-20180326-SHL-LHCvsDIF-20172018-.csv")


d <- rbind(data1,data2,data3,data4,data5,
           data6,data7,data8,data9,data10,
           data11,data12,data13,data14,data15,
           data16,data17,data18,data19,data20,
           data21,data22,data23,data24,data25,
           data26,data27,data28,data29,data30,
           data31,data32,data33,data34,data35,
           data36,data37,data38,data39,data40,
           data41,data42,data43,data44,data45,
           data46,data47,data48,data49,data50,
           data51,data52,data53,data54,data55,
           data56,data57,data58,data59)

players_ref <- unique(d$playerReferenceId)
players_ref <- players_ref[-1] #NULL
players_surname <- rep(0, length(players_ref))
for(i in 1: length(players_ref)){
  players_surname[i] <- unique(as.character(d$playerLastName[which(d$playerReferenceId == players_ref[i])]))
}

players_name <- rep(0, length(players_ref))
for(i in 1: length(players_ref)){
  players_name[i] <- unique(as.character(d$playerFirstName[which(d$playerReferenceId == players_ref[i])]))
}
players <- cbind(players_ref,players_name, players_surname)

save(players, file = "players.Rdata")

all_season_data <- d[which(d$name == "shot"),]

save(all_season_data, file = "all_season_data.Rdata")
write.csv(all_season_data, file = "all_season_data.csv", row.names = FALSE)

