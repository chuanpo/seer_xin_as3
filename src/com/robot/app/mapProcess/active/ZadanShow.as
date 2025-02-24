package com.robot.app.mapProcess.active
{
   import com.robot.core.config.ClientConfig;
   import com.robot.core.mode.AppModel;
   
   public class ZadanShow
   {
      private static var panel_zd:AppModel;
      
      private static var zdOjb:Object;
      
      public static const GET_NOTHING:String = "sendgetnothing";
      
      public function ZadanShow()
      {
         super();
      }
      
      public static function show(n:uint) : void
      {
         if(panel_zd == null)
         {
            zdOjb = new Object();
            zdOjb.num = n;
            panel_zd = new AppModel(ClientConfig.getAppModule("ZadanPanel"),"正在打开抽奖信息");
            panel_zd.setup();
            panel_zd.show();
            panel_zd.init(zdOjb);
         }
         else
         {
            zdOjb.num = n;
            panel_zd.init(zdOjb);
            panel_zd.show();
         }
      }
   }
}

