#include "E_DIRECTION.mqh"
#include "E_StateMachine.mqh"

struct stGlobalVars
{
   E_DIRECTION eCurrentDirection;
   E_StateMachine eStateMachine;
   E_StateMachine eStateMachine_Last;
   MqlRates Candle[];
   MqlRates CandleHigherTF[];
   datetime dtCurrentTime;
   datetime dtCurrentDay;
   datetime dtLastDay;
   datetime dtTimeCurrent_CurrTF;
   datetime dtTimeLast_CurrTF;
   datetime dtTimeCurrent_HigherTF;
   datetime dtTimeLast_HigherTF;
   int nActualHour;
   int nNumberOfTrades;
   int nNumberOfPositions;
   
   double BodyStopLoss;
   double StopLoss;
   double TakeProfit;
   double Entry;
   double LotSize;
   
   MqlCalendarValue NewsValues[];
   bool bFilterActive;
   double DailyStartingBalance;
   
   bool bTPChecked;
   bool MovedBE;
   bool bRunnerPosition_CheckClose;
   double fDistanceMoveRunnerSLTP1_Price;
   
   datetime ServerTime;
   datetime GMTTime;
   
   string Rect_FVG;
   int Rect_ActFVG_Number;
   double LastFVGTop;
   double LastFVGBottom;
   int LastFVGIndex;
   datetime dtFVGReached_Time;
   datetime dtFVGCreated_Time;
   
   int nSmallEMAHandle;
   int nBigEMAHandle;
   double SmallEMABuffer[];
   double BigEMABuffer[];
   
   int nSmallEMAHandle_CurrTF;
   int nBigEMAHandle_CurrTF;
   double SmallEMABuffer_CurrTF[];
   double BigEMABuffer_CurrTF[];
   
   double fMinDiffEMA_Price;
   
};