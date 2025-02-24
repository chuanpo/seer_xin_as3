package com.robot.core.pet.petWar
{
   import com.robot.core.CommandID;
   import com.robot.core.event.PetFightEvent;
   import com.robot.core.info.fightInfo.PetFightModel;
   import com.robot.core.info.fightInfo.PetWarInfo;
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.manager.PetManager;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.utils.TextFormatUtil;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.EventManager;
   
   public class PetWarController
   {
      private static var _allPetA:Array = [];
      
      private static var _allPetMc:Array = [];
      
      public static var allPetIdA:Array = [];
      
      public static var myCapA:Array = [];
      
      public static var myPetInfoA:Array = [];
      
      public function PetWarController()
      {
         super();
      }
      
      public static function start(handler:Function = null) : void
      {
         if(PetManager.getBagMap().length < 3)
         {
            if(handler != null)
            {
               handler();
            }
            Alarm.show("你需要带上3只以上的精灵才能参加精灵大乱斗哦。");
            return;
         }
         PetFightModel.mode = PetFightModel.MULTI_MODE;
         EventManager.addEventListener(PetFightEvent.GET_FIGHT_INFO_SUCCESS,onGetInfoSuceessHandler);
         EventManager.addEventListener(PetFightEvent.ALARM_CLICK,onClickHandler);
         SocketConnection.addCmdListener(CommandID.PET_WAR_EXP_NOTICE,onExpHandler);
         SocketConnection.send(CommandID.START_PET_WAR);
         SocketConnection.addCmdListener(CommandID.START_PET_WAR,onStartHandler);
         PetFightModel.mode = PetFightModel.PET_MELEE;
      }
      
      private static function onClickHandler(e:PetFightEvent) : void
      {
         EventManager.removeEventListener(PetFightEvent.ALARM_CLICK,onClickHandler);
         PetFightModel.mode = PetFightModel.SINGLE_MODE;
      }
      
      private static function onExpHandler(e:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.PET_WAR_EXP_NOTICE,onExpHandler);
         var by:ByteArray = e.data as ByteArray;
         var exp:uint = by.readUnsignedInt();
         Alarm.show("祝贺你得到了 " + TextFormatUtil.getRedTxt(exp.toString()) + " 点积累经验!");
      }
      
      public static function onStartHandler(e:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.START_PET_WAR,onStartHandler);
      }
      
      public static function onGetInfoSuceessHandler(e:PetFightEvent) : void
      {
         EventManager.removeEventListener(PetFightEvent.GET_FIGHT_INFO_SUCCESS,onGetInfoSuceessHandler);
         var obj:PetWarInfo = e.dataObj as PetWarInfo;
         allPetIdA = obj.myPetA.concat(obj.otherPetA);
      }
      
      public static function destroy() : void
      {
      }
      
      public static function set allPetA(a:Array) : void
      {
         _allPetA = a;
      }
      
      public static function get allPetA() : Array
      {
         return _allPetA;
      }
      
      public static function getPetInfo(cap:Number) : PetInfo
      {
         var info:PetInfo = null;
         for each(info in _allPetA)
         {
            if(info.catchTime == cap)
            {
               return info;
            }
         }
         return null;
      }
      
      public static function getMyPet(index:uint) : PetInfo
      {
         if(index >= myPetInfoA.length)
         {
            return null;
         }
         return myPetInfoA[index];
      }
   }
}

