package com.robot.core.info.fightInfo.attack
{
   import com.robot.core.event.RobotEvent;
   import com.robot.core.manager.MainManager;
   import flash.utils.IDataInput;
   import org.taomee.manager.EventManager;
   
   public class FightOverInfo
   {
      private var _winnerID:uint;
      
      private var _reason:uint;
      
      public function FightOverInfo(data:IDataInput)
      {
         super();
         this._reason = data.readUnsignedInt();
         this._winnerID = data.readUnsignedInt();
         var two:uint = uint(data.readUnsignedInt());
         var three:uint = uint(data.readUnsignedInt());
         MainManager.actorInfo.twoTimes = two;
         MainManager.actorInfo.threeTimes = three;
         MainManager.actorInfo.autoFightTimes = data.readUnsignedInt();
         var energyt:uint = uint(data.readUnsignedInt());
         var studyTime:uint = uint(data.readUnsignedInt());
         MainManager.actorInfo.energyTimes = energyt;
         MainManager.actorInfo.learnTimes = studyTime;
         EventManager.dispatchEvent(new RobotEvent(RobotEvent.ENERGY_TIMES_CHANGE));
         EventManager.dispatchEvent(new RobotEvent(RobotEvent.SPEEDUP_CHANGE));
         EventManager.dispatchEvent(new RobotEvent(RobotEvent.AUTO_FIGHT_CHANGE));
         EventManager.dispatchEvent(new RobotEvent(RobotEvent.STUDY_TIMES_CHANGE));
      }
      
      public function get winnerID() : uint
      {
         return this._winnerID;
      }
      
      public function get reason() : uint
      {
         return this._reason;
      }
   }
}

