//+------------------------------------------------------------------+
//|                                                   |
//|                                 Copyright 2015, yjx |
//|                                              http://www.yjx.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018."
#property link      "http://www.yjx.com"

class CFilter
{  
   private:
      CTrend* oCTrend;
      CLaguerreRsi* oCLRsi;
      CMacd* oMacd;
      string mTrend;
      int mTf;  //过滤时间框架
      
      
   public:
      
      
      CFilter(int _mTf,CTrend* _oCTrend, CLaguerreRsi* _oCLRsi, CMacd* _oMacd){
         mTf = _mTf;
         oCTrend = _oCTrend;
         oCLRsi = _oCLRsi;
         oMacd = _oMacd;
         mTrend = "none";
      };
      void Tick();
      bool GetCheckResult();
      
};

void CFilter::Tick(void)
{
   
   if(mTrend == "long"){
      mTrend = oCTrend.GetTrend();
      if(mTrend == "long"){
         if(oCLRsi.data[1]<0.1){
             CDrawLine::Vline(TimeCurrent(), clrRed);
         }else if(oMacd.data[1]>0.2){
            //CDrawLine::Vline(TimeCurrent(), clrOrange);
         }
      }
   }
   if(mTrend == "short"){
      mTrend = oCTrend.GetTrend();
      if(mTrend == "short"){
         if(oCLRsi.data[1]>0.9){
             CDrawLine::Vline(TimeCurrent(), clrRed);
         }else if(oMacd.data[1]<-0.2){
           // CDrawLine::Vline(TimeCurrent(), clrOrange);
         }
      }
   }
   if(mTrend == "none"){
      mTrend = oCTrend.GetTrend();
   }
   /*
   if(mTrend == "none"){
      if(oCTrend.GetTrend() != mTrend){
         mTrend = oCTrend.GetTrend();
         if(mTrend == "long"){
            if(oMacd.data[1]>=0){
               CDrawLine::Vline(TimeCurrent(), clrLime);
            }else{
               CDrawLine::Vline(TimeCurrent(), clrRed);
            }
         }else if(mTrend == "short"){
            if(oMacd.data[1]<=0){
               CDrawLine::Vline(TimeCurrent(), clrLime);
            }else{
               CDrawLine::Vline(TimeCurrent(), clrRed);
            }
         }
      }
   }else if(mTrend == "long"){
      mTrend = oCTrend.GetTrend();
      if(mTrend == "long"){
         if(oMacd.data[2]>=0 && oMacd.data[1]<0){
             CDrawLine::Vline(TimeCurrent(), clrRed);
         }
         if(oMacd.data[2]<=0 && oMacd.data[1]>0){
             CDrawLine::Vline(TimeCurrent(), clrLime);
         }
      }
   }else if(mTrend == "short"){
      mTrend = oCTrend.GetTrend();
      if(mTrend == "short"){
         if(oMacd.data[2]<=0 && oMacd.data[1]>0){
             CDrawLine::Vline(TimeCurrent(), clrRed);
         }
         if(oMacd.data[2]>=0 && oMacd.data[1]<0){
             CDrawLine::Vline(TimeCurrent(), clrLime);
         }
      }
   }
   */
}

bool CFilter::GetCheckResult()
{
   if(mTrend == "none")return false;
   if(mTrend == "long"){
      if(oMacd.data[1]>0){
         return true;
      }
      return false;
   }
   if(mTrend == "short"){
      if(oMacd.data[1]<0){
         return true;
      }
      return false;
   }
   return false;
}