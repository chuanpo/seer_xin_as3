package com.robot.app.fightLevel
{
   import com.robot.core.CommandID;
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.info.pet.PetListInfo;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.PetManager;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import org.taomee.events.SocketEvent;
   
   public class FightMHTController
   {
      private static var _handler:Function;
      
      private static var _petInfoA:Array = [];
      
      private static var _curIndex:uint = 0;
      
      public function FightMHTController()
      {
         super();
      }
      
      public static function check() : void
      {
         if(PetManager.getBagMap().length < 6)
         {
            Alarm.show("只有具备了足够的实力才能进入勇者之塔神秘领域，等你将6只精灵全都训练到100级后再来挑战吧。");
            return;
         }
         _petInfoA = PetManager.getBagMap();
         _curIndex = 0;
         send1((_petInfoA[_curIndex] as PetListInfo).catchTime);
      }
      
      public static function checkIsFight(fun:Function) : void
      {
         _handler = fun;
         _petInfoA = PetManager.getBagMap();
         _curIndex = 0;
         send((_petInfoA[_curIndex] as PetListInfo).catchTime);
      }
      
      private static function send(capTime:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.GET_PET_INFO,onCheckComHandler);
         SocketConnection.send(CommandID.GET_PET_INFO,capTime);
      }
      
      private static function send1(capTime:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.GET_PET_INFO,onGetComHandler);
         SocketConnection.send(CommandID.GET_PET_INFO,capTime);
      }
      
      private static function onCheckComHandler(e:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.GET_PET_INFO,onCheckComHandler);
         var info:PetInfo = e.data as PetInfo;
         if(info.level >= 30)
         {
            _handler(true);
            return;
         }
         ++_curIndex;
         if(_curIndex < _petInfoA.length)
         {
            send((_petInfoA[_curIndex] as PetListInfo).catchTime);
         }
         else
         {
            _handler(false);
         }
      }
      
      private static function onGetComHandler(e:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.GET_PET_INFO,onGetComHandler);
         var info:PetInfo = e.data as PetInfo;
         if(info.level < 100)
         {
            Alarm.show("只有具备了足够的实力才能进入勇者之塔神秘领域，等你将6只精灵全都训练到100级后再来挑战吧。");
            destroy();
         }
         else
         {
            ++_curIndex;
            if(_curIndex > 5)
            {
               destroy();
               MapManager.changeLocalMap(514);
            }
            else
            {
               send1((_petInfoA[_curIndex] as PetListInfo).catchTime);
            }
         }
      }
      
      public static function destroy() : void
      {
         SocketConnection.removeCmdListener(CommandID.GET_PET_INFO,onGetComHandler);
         _petInfoA = null;
         _curIndex = 0;
      }
   }
}

