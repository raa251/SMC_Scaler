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
   
   bool MovedBE;
   bool bRunnerPosition_CheckClose;
   
   datetime ServerTime;
   datetime GMTTime;
   
   string Rect_FVG;
   int Rect_ActFVG_Number;
   double LastFVGTop;
   double LastFVGBottom;
   int LastFVGIndex;
   datetime dtFVGReached_Time;
   datetime dtFVGCreated_Time;
   
   bool bWaitForNextHigherTFCandle;
};