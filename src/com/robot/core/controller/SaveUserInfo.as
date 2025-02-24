package com.robot.core.controller
{
   import com.robot.core.config.ClientConfig;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.SOManager;
   import flash.net.SharedObject;
   
   public class SaveUserInfo
   {
      private static const USERCOUNT:int = 3;
      
      private static var mySo:SharedObject = SOManager.getCommon_login();
      
      public static var isSave:Boolean = false;
      
      public static var pass:String = "";
      
      private static var vesion:uint = 0;
      
      private static var newsSo:SharedObject = SOManager.getNews_Read();
      
      public function SaveUserInfo()
      {
         super();
      }
      
      public static function saveSo() : void
      {
         var i:int = 0;
         if(!SaveUserInfo.isSave)
         {
            return;
         }
         var userAry:Array = SaveUserInfo.getUserInfo();
         if(userAry == null)
         {
            userAry = new Array();
         }
         else if(userAry.length <= USERCOUNT)
         {
            for(i = 0; i < userAry.length; i++)
            {
               if(MainManager.actorID == userAry[i].id)
               {
                  userAry.splice(i,1);
               }
            }
         }
         userAry.push({
            "id":MainManager.actorID,
            "nickName":MainManager.actorInfo.nick,
            "color":MainManager.actorInfo.color,
            "pwd":SaveUserInfo.pass,
            "clothes":MainManager.actorInfo.clothIDs,
            "texture":MainManager.actorInfo.texture
         });
         if(userAry.length > 3)
         {
            userAry.shift();
         }
         mySo.data.ousers = userAry;
         SOManager.flush(mySo);
      }
      
      public static function saveNewsSO() : void
      {
         vesion = ClientConfig.newsVersion;
         newsSo.data.version = vesion;
         newsSo.data.userId = MainManager.actorInfo.userID;
         SOManager.flush(newsSo);
      }
      
      public static function getUserInfo() : Array
      {
         return mySo.data.ousers;
      }
      
      public static function getNewsVersion() : Object
      {
         var obj:Object = new Object();
         obj.id = newsSo.data.userId;
         obj.version = newsSo.data.version;
         return obj;
      }
   }
}

