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
   double InitialBalance;
   double fMaxObservedDailyLossPct;
   double fMaxObservedTotalDDPct;
   double MonthStartingBalance;
   int nLastMonthKey;
   
   bool bTPChecked;
   bool MovedBE;
   bool bRunnerPosition_CheckClose;
   double fDistanceMoveRunnerSLTP1_Price;
   
   datetime ServerTime;
   datetime GMTTime;
   
   ST_FVG stFVG;       // Fair value gap to inverse, current timeframe
   ST_FVG stFVG_HTF;   // Fair value gap for liquidity, higher timeframe
   datetime dtFVGReached_Time_HTF;
   datetime dtFVGCreated_Time_HTF;
   
   int nSmallEMAHandle;
   int nBigEMAHandle;
   double SmallEMABuffer[];
   double BigEMABuffer[];
   
   int nSmallEMAHandle_CurrTF;
   int nBigEMAHandle_CurrTF;
   double SmallEMABuffer_CurrTF[];
   double BigEMABuffer_CurrTF[];
   
   double fMinDiffEMA_Price;
   double fMinFVGSize_Price;
   double fMaxFVGSize_Price;
   double fMinIFVGSize_Price;
   double fMaxIFVGSize_Price;
   double fMaxDistanceFVGInverse_Price;
   double fMinSLDistance_Price;
   
   // Trend Structure
   E_DIRECTION eTrendStructure_HTF;
   double fLastHigh_HTF;
   int nLastHighIndex_HTF;
   double fLastLow_HTF;
   int nLastLowIndex_HTF;
   
   E_DIRECTION eTrendStructure_CTF;
   double fLastHigh_CTF;
   int nLastHighIndex_CTF;
   double fLastLow_CTF;
   int nLastLowIndex_CTF;
   
   bool bWaitForNewCurrBar;
};