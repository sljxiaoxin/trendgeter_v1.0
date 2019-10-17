//+------------------------------------------------------------------+
//|                                                   |
//|                                 Copyright 2015    |
//|                                              yangjx009@139.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018."
#property link      "http://www.yjx.com"


#include "base\CMacd.mqh";
#include "base\CLaguerreRsi.mqh";

#include "util\CDrawLine.mqh";
#include "util\CDrawRect.mqh";


#include "trade\CTrade.mqh";
#include "trade\CTicket.mqh";
#include "trade\CTrend.mqh";
#include "trade\CFilter.mqh";

class CStrategy
{  
   private:
     datetime CheckTimeTrend;
     datetime CheckTimeFilter;
     datetime CheckTimeEntry; 
     double   Lots;
     int      Tp;
     int      Sl;
     int      TrendTF;
     int      FilterTF;
     int      EntryTF;
     
     
     CLaguerreRsi* oCLRsi_Trend;
     CMacd* oMacdMain_Trend;
     CTrend* oCTrend;
     
     CMacd* oMacdMain_Filter;
     CFilter* oCFilter;
     
     
    
     void Update();
     void GetTrend();
     void OnTrendChange(); //trend change callback
     
     
     
     
   public:
      
      CStrategy(int Magic, int Input_TrendTF, int Input_FilterTF, int Input_EntryTF){
         TrendTF  = Input_TrendTF;
         FilterTF = Input_FilterTF;
         EntryTF  = Input_EntryTF;
         
         //oCTrade        = new CTrade(Magic);
         
         oCLRsi_Trend = new CLaguerreRsi(TrendTF,0);
         oMacdMain_Trend = new CMacd(TrendTF,MODE_MAIN);
         oMacdMain_Filter = new CMacd(FilterTF,MODE_MAIN);
        
         oCTrend = new CTrend(TrendTF, oCLRsi_Trend, oMacdMain_Trend);
         oCFilter = new CFilter(FilterTF,oCTrend,oMacdMain_Filter);
         
      };
      
      void Init(double _lots, int _tp, int _sl);
      void Tick();
      void Entry();
      void Exit();
      void CheckOpen();
      string getTrend();
      
};

void CStrategy::Init(double _lots, int _tp, int _sl)
{
   Lots = _lots;
   Tp = _tp;
   Sl = _sl;
}

void CStrategy::Tick(void)
{  
    
    //every M5
    if(CheckTimeEntry != iTime(NULL,EntryTF,0)){
         CheckTimeEntry = iTime(NULL,EntryTF,0);
         this.Update();
         oCTrend.TickEntry(EntryTF);
         
    }
    
    //every H1
    if(CheckTimeTrend != iTime(NULL,TrendTF,0)){
         CheckTimeTrend = iTime(NULL,TrendTF,0);
         oCTrend.Tick();
    }
    
    
    if(CheckTimeFilter != iTime(NULL,FilterTF,0)){
         CheckTimeFilter = iTime(NULL,FilterTF,0);
         oCFilter.Tick();
    }
    
   // CheckOpen();
}



void CStrategy::Update()
{
   oCLRsi_Trend.Fill();
   oMacdMain_Trend.Fill();
   oMacdMain_Filter.Fill();
   //oCTicket.Update();
}

string CStrategy::getTrend()
{
   return oCTrend.GetTrend();
}

void CStrategy::GetTrend()
{

   
}


void CStrategy::OnTrendChange()
{
   
}


void CStrategy::Exit()
{
   
}

void CStrategy::Entry()
{
   
}