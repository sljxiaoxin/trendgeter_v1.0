//+------------------------------------------------------------------+
//
//+------------------------------------------------------------------+
#property copyright "xiaoxin003"
#property link      "yangjx009@139.com"
#property version   "1.0"
#property strict

#include "CStrategy.mqh";
 
extern int       Input_MagicNumber  = 20190928;    
extern double    Input_Lots         = 0.1;
extern int       Input_intTP        = 0;
extern int       Input_intSL        = 0;
extern string    Memo_TrendTF       = "---trend timeframe default H1---";
extern ENUM_TIMEFRAMES Input_TrendTF      = PERIOD_H1;

extern string    Memo_FilterTF      = "---filter timeframe default M15---";
extern ENUM_TIMEFRAMES Input_FilterTF     = PERIOD_M30;

extern string    Memo_EntryTF      = "---trade entry timeframe default Current---";
extern ENUM_TIMEFRAMES Input_EntryTF     = PERIOD_CURRENT;
      

CStrategy* oCStrategy;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
//---
   Print("begin");
   if(oCStrategy == NULL){
      oCStrategy = new CStrategy(Input_MagicNumber,Input_TrendTF,Input_FilterTF,Input_EntryTF);
   }
   oCStrategy.Init(Input_Lots,Input_intTP,Input_intSL);
   
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   Print("deinit");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

void OnTick()
{
   oCStrategy.Tick();
   subPrintDetails();
}


void subPrintDetails()
{
   //
   string sComment   = "";
   string sp         = "----------------------------------------\n";
   string NL         = "\n";

   sComment = sp;
   sComment = sComment + "Trend = " + oCStrategy.getTrend() + NL; 
   sComment = sComment + sp;
   //sComment = sComment + "TotalItemsActive = " + oCOrder.TotalItemsActive() + NL; 
   sComment = sComment + sp;
   //sComment = sComment + "Lots=" + DoubleToStr(Lots,2) + NL;
   Comment(sComment);
}


