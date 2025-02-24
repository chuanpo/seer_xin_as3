package com.robot.core.manager.map.config
{
   import com.robot.core.manager.map.MapType;
   import org.taomee.utils.Utils;
   
   public class MapProcessConfig
   {
      public static var currentProcessInstance:BaseMapProcess;
      
      private static var PATH:String = "com.robot.app.mapProcess.MapProcess_";
      
      public function MapProcessConfig()
      {
         super();
      }
      
      public static function configMap(id:uint, mapType:uint = 0) : void
      {
         var str:String = null;
         if(id > 50000)
         {
            switch(mapType)
            {
               case MapType.HOOM:
                  str = "com.robot.app.mapProcess.RoomMap";
                  break;
               case MapType.CAMP:
                  str = "com.robot.app.mapProcess.FortressMap";
                  break;
               case MapType.HEAD:
                  str = "com.robot.app.mapProcess.HeadquartersMap";
                  break;
               case MapType.PK_TYPE:
                  str = "com.robot.app.mapProcess.PKMap";
            }
            if(str == null || str == "")
            {
               return;
            }
         }
         else
         {
            str = PATH + id.toString();
         }
         var cls:Class = Utils.getClass(str);
         if(Boolean(cls))
         {
            currentProcessInstance = new cls() as BaseMapProcess;
         }
         else
         {
            currentProcessInstance = new BaseMapProcess();
            trace("没有对应的地图功能类");
         }
      }
      
      public static function destroy() : void
      {
         if(Boolean(currentProcessInstance))
         {
            currentProcessInstance.destroy();
         }
         currentProcessInstance = null;
      }
   }
}

