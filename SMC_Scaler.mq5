// Original SMC Scaler by raphix251
#property copyright "raphix251"



// Include all mqh files
// Libraries
#include "IncludeLibrarys.mqh"



//--- INPUT PARAMETERS
// Money Management parameters
input string   Section_MoneyManagement = ""; // ---MONEY MANAGEMENT---
input double   fRiskPerTrade = 1;            // Risk per trade
input int      nMaxTradesPerDay = 5;         // Maximum trades per day
input double   fLossPerLot = 0;              // Loss per lot in dollar
input int      nMaxSpread = 0;               // Maximum spread in points
input double   nMaxDailyProfit = 0;          // Maximum daily profit in percent
input double   nMaxDailyLoss = 0;            // Maximum daily loss in percent

// Strategy parameters
input string   Section_Strategy        = "";    // ---STRATEGY---
input double   fRiskReward = 2.0;               // Risk reward ratio
input double   nMoveBeAtProfit = 0;             // Move break even at profit
input int      nMaxCandlesToReachFVG = 30;      // Maximum candles to reach FVG
input double   fMaxDipIntoFVG = 0;               // Maximum dip into FVG in percent
input int      nCandlesLookbackFVG = 10;        // Number of candles to look back for IFVG
input int      nMaxCandlesFVGInverse = 10;      // Maximum candles to inverse FVG
input int      nMaxDistanceFVGInverse = 0;      // Maximum distance to inverse FVG
input ENUM_TIMEFRAMES eHigherTF = PERIOD_M15;   // Higher timeframe for liquidity search
input bool     bRunnerPosition = false;         // Runner position
input E_TREND_FILTER eRunnerClose = EMA;        // Runner position  close mode
input int      nDistanceMoveRunnerSLTP1 = 0;    // Distance to move SL of runner to TP1
input E_TREND_FILTER eTrendFilter = NONE;       // Trend filter mode
input E_SL_PLACEMENT eSLPlacement = LAST_STRUCTURE_BODY; // Stoploss placement
input bool     bSearchFVGWithinHTF_FVG = true;  // Search FVG within HTF FVG
input int      nMinFVGSize = 0;                // Minimum FVG size(HTF)
input int      nMaxFVGSize = 0;                // Maximum FVG size(HTF)
input int      nMinIFVGSize = 0;               // Minimum IFVG size(CTF)
input int      nMaxIFVGSize = 0;               // Maximum IFVG size(CTF)

// Structure parameters
input string   Section_Structure             = ""; // ---STRUCTURE FILTER---
input int      nFreeCandlesForExtrema_Right  = 2;  // Free candles on right side for new extrema
input int      nFreeCandlesForExtrema_Left   = 2;  // Free candles on left side for new extrema

// Time filter parameters
input string   Section_TimeFilter      = ""; // ---TIME FILTER---
input int      nStartTime1 = 8;              // Start time
input int      nEndTime1 = 20;               // End time
input int      nStartTime2 = -1;             // Start time
input int      nEndTime2 = -1;               // End time

// Day filter parameters
input string   Section_DayFilter       = ""; // ---DAY FILTER---
input bool     bMonday     = true;           // Monday
input bool     bTuesday    = true;           // Tuesday
input bool     bWednesday  = true;           // Wednesday
input bool     bThursday   = true;           // Thursday
input bool     bFriday     = true;           // Friday

// EMA filter parameters
input string   Section_EMAFilter     = ""; // ---EMA FILTER---
input ENUM_TIMEFRAMES eEMATimeframe = PERIOD_CURRENT; // EMA timeframe(Filter)
input int nSmallEMALength = 20;                       // Small EMA length
input int nBigEMALength = 50;                         // Big EMA length
input int nMinDiffEMA = 0;                            // Minimum difference between small and big EMA

// News filter parameters
input string   Section_NewsFilter      = ""; // ---NEWS FILTER---
input int      nNewsMinutesBefore = 30;                                          // No entries before news in minutes
input int      nNewsMinutesAfter = 10;                                           // No entries after news in minutes
input ENUM_CALENDAR_EVENT_IMPORTANCE eNewsImportance = CALENDAR_IMPORTANCE_NONE; // Minimum news importance
input string   sNewsCurrency1 = "USD";                                            // News currency to look for
input string   sNewsCurrency2 = "";                                               // News currency to look for
input string   sNewsCurrency3 = "";                                               // News currency to look for
input string   sNewsCurrency4 = "";                                               // News currency to look for
input string   sNewsCurrency5 = "";                                               // News currency to look for

// Debug
input string   Section_Debug           = ""; // ---DEBUG---
input datetime dtDebugTime;                  // Debug time breakpoint (only for testing purpose)

stGlobalVars stGVL;
CTrade Trade;
int nMaxCandles;
int nMaxCandlesHigherTF;
datetime tmpDebugTime;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   M_Points2Price();
   
   tmpDebugTime = dtDebugTime;
   
   M_SetBoxNames();
   
   M_EMA_INIT();
   
   M_CreateLabel("FilterLabel",5,10);
   M_CreateLabel("GMTTime",5,40);
   M_CreateLabel("ServerTime",5,80);
   
   nMaxCandles = 4;
   nMaxCandles = MathMax(nCandlesLookbackFVG + 3,nMaxCandles); // 3 Because a FVG exists out of 3 candles
   nMaxCandles = MathMax(nMaxCandlesFVGInverse + 1,nMaxCandles);
   nMaxCandles = MathMax(nMaxCandlesToReachFVG, nMaxCandles);
   nMaxCandles = MathMax(nFreeCandlesForExtrema_Left + 2 + nFreeCandlesForExtrema_Right + 1, nMaxCandles);
   nMaxCandles = MathMin(nMaxCandles, 100);
   
   nMaxCandlesHigherTF = 3 + 1; // 3 Candles are needed for FVG + 1 because the first one is not closed yet
   nMaxCandlesHigherTF = MathMax(nFreeCandlesForExtrema_Left + 2 + nFreeCandlesForExtrema_Right + 1, nMaxCandlesHigherTF);
   
   if(bRunnerPosition && eRunnerClose == NONE)
   {
      Alert("Runner close mode NONE is not allowed");
      M_LogError("Runner close mode NONE is not allowed");
      return(INIT_PARAMETERS_INCORRECT);
   }
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
      
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   M_GetCandleData(PERIOD_CURRENT, stGVL.Candle, nMaxCandles);
   M_GetCandleData(eHigherTF, stGVL.CandleHigherTF, nMaxCandlesHigherTF);
   
   M_DetermineTimes();
   
   M_StateMachine();
   
   if(stGVL.dtTimeCurrent_CurrTF != stGVL.dtTimeLast_CurrTF)
   {
      M_NewBar_CurrTF();
      stGVL.dtTimeLast_CurrTF = stGVL.dtTimeCurrent_CurrTF;
   }
}