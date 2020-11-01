library('dplyr')
library('data.table')
library(SportsAnalytics)
NBA1516<-fetch_NBAPlayerStatistics("15-16")
NBA1516DT<-data.table(NBA1516)
class(NBA1516DT)

NBA1516DT[grepl('James',Name)]
NBA1516DT[grepl('A',Name)&Position=="C"]
NBA1516DT[GamesPlayed>80]
NBA1516DT[,mean(GamesPlayed)] ##因沒有篩選需求，,前方留空
#也可以一次計算多個數值，如同時計算平均出場數、平均犯規次數以及平均抄截次數，此時第二個欄位j需要使用.()包起來
NBA1516DT[,.(mean(GamesPlayed),mean(PersonalFouls),mean(Steals))] ##因沒有篩選需求，,前方留空

NBA1516DT[,.(GamesPlayedMean=mean(GamesPlayed),
             PersonalFoulsMean=mean(PersonalFouls),
             StealsMean=mean(Steals))]

NBA1516DT[,.(GamesPlayedMax=max(GamesPlayed), #最大值
             ThreesMadeMin=min(ThreesMade), #最小值
             FieldGoalsMadeSD=sd(FieldGoalsMade))] #標準差

NBA1516DT[GamesPlayed>70,
          .(ThreesMadeMean=mean(ThreesMade), FieldGoalsMadeMean=mean(FieldGoalsMade))]
#第三個參數by為分組計算的依據，舉例來說，我們可以計算NBA各隊的球員數與平均助攻數，
#球員個數的計算在data.table內可使用.N指令，平均使用mean()函數，此時只要在by=後方加上分組依據(各隊Team)，即可完成運算
NBA1516DT[,.(.N,AssistsMean=mean(Assists)),
          by=Team]
#.N在data.table內是保留字，用來計算個數
#三個參數結合使用，可以輕鬆計算出NBA各隊的中鋒球員數和他們的平均三分球出手次數，指令如下：
NBA1516DT[Position=="C",
          .(.N,ThreesAttemptedMean=mean(ThreesAttempted)),
          by=Team]
