package com.robot.core.aticon
{
   import com.robot.core.CommandID;
   import com.robot.core.aimat.AimatController;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.config.xml.SuitXMLInfo;
   import com.robot.core.controller.SaveUserInfo;
   import com.robot.core.event.UserEvent;
   import com.robot.core.info.clothInfo.PeopleItemInfo;
   import com.robot.core.info.item.DoodleInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.skeleton.TransformSkeleton;
   import flash.utils.ByteArray;
   import org.taomee.manager.EventManager;
   
   public class FigureAction
   {
      public function FigureAction()
      {
         super();
      }
      
      public function changeCloth(obj:BasePeoleModel, data:Array, isNet:Boolean = true) : void
      {
         var i:PeopleItemInfo = null;
         var count:uint = 0;
         var byte:ByteArray = null;
         var array:Array = null;
         if(isNet)
         {
            count = data.length;
            byte = new ByteArray();
            for each(i in data)
            {
               byte.writeUnsignedInt(i.id);
            }
            SocketConnection.send(CommandID.CHANGE_CLOTH,count,byte);
         }
         else
         {
            obj.skeleton.takeOffCloth();
            obj.skeleton.changeCloth(data);
            obj.info.clothes = data;
            if(obj.skeleton is TransformSkeleton)
            {
               if(SuitXMLInfo.getSuitID(obj.info.clothIDs) == 0)
               {
                  TransformSkeleton(obj.skeleton).untransform();
               }
               else if(!SuitXMLInfo.getIsTransform(SuitXMLInfo.getSuitID(obj.info.clothIDs)))
               {
                  TransformSkeleton(obj.skeleton).untransform();
               }
            }
            SaveUserInfo.saveSo();
            array = [];
            for each(i in data)
            {
               array.push(i.id);
            }
            if(obj.info.userID == MainManager.actorID)
            {
               AimatController.setClothType(array);
            }
            obj.speed = ItemXMLInfo.getSpeed(array);
            EventManager.dispatchEvent(new UserEvent(UserEvent.INFO_CHANGE,obj.info));
            obj.showClothLight();
         }
      }
      
      public function changeNickName(obj:BasePeoleModel, nick:String, isNet:Boolean = true) : void
      {
         var nickBytes:ByteArray = null;
         if(isNet)
         {
            nickBytes = new ByteArray();
            nickBytes.writeUTFBytes(nick);
            nickBytes.length = 16;
            SocketConnection.send(CommandID.CHANG_NICK_NAME,nickBytes);
         }
         else
         {
            obj.info.nick = nick;
            EventManager.dispatchEvent(new UserEvent(UserEvent.INFO_CHANGE,obj.info));
         }
      }
      
      public function changeColor(obj:BasePeoleModel, color:uint, isNet:Boolean = true) : void
      {
         if(isNet)
         {
            SocketConnection.send(CommandID.CHANGE_COLOR,color);
         }
         else
         {
            obj.skeleton.changeColor(color);
            obj.info.color = color;
            obj.info.texture = 0;
            SaveUserInfo.saveSo();
         }
      }
      
      public function changeDoodle(obj:BasePeoleModel, df:DoodleInfo, isNet:Boolean = true) : void
      {
         if(df.texture == 0)
         {
            this.changeColor(obj,df.color);
            return;
         }
         if(isNet)
         {
            SocketConnection.send(CommandID.CHANGE_DOODLE,df.id);
         }
         else
         {
            obj.info.texture = df.texture;
            obj.info.color = df.color;
            obj.info.coins = df.coins;
            if(df.URL == "" || df.URL == null)
            {
               return;
            }
            obj.skeleton.changeDoodle(df.URL);
            obj.skeleton.changeColor(df.color,false);
            SaveUserInfo.saveSo();
         }
      }
   }
}

