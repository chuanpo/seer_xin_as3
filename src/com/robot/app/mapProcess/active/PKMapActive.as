package com.robot.app.mapProcess.active
{
   import com.robot.core.CommandID;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.UserManager;
   import com.robot.core.manager.map.MapLibManager;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.ItemInBagAlert;
   import com.robot.core.utils.TextFormatUtil;
   import flash.display.MovieClip;
   import flash.utils.ByteArray;
   import gs.TweenLite;
   import org.taomee.ds.HashMap;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class PKMapActive
   {
      private const NONE:uint = 0;
      
      private const ATTACK:uint = 1;
      
      private const STONE:uint = 2;
      
      private var estradeMC:MovieClip;
      
      private var flag:uint;
      
      private var attackMC:MovieClip;
      
      private var stoneMC:MovieClip;
      
      private var timerMap:HashMap;
      
      public function PKMapActive()
      {
         super();
         SocketConnection.addCmdListener(CommandID.TEAM_PK_ACTIVE,this.onPKActive);
         SocketConnection.addCmdListener(CommandID.TEAM_PK_ACTIVE_NOTE_GET_ITEM,this.onNoteGetItem);
         this.estradeMC = MapManager.currentMap.depthLevel["estradeMC"];
         this.estradeMC.mouseEnabled = this.estradeMC.mouseChildren = false;
         this.attackMC = MapLibManager.getMovieClip("attack_mc");
         this.stoneMC = MapLibManager.getMovieClip("stone_mc");
         this.stoneMC.y = -40;
         this.attackMC.y = -40;
         this.stoneMC.mouseChildren = this.stoneMC.mouseEnabled = false;
         this.attackMC.mouseChildren = this.attackMC.mouseEnabled = false;
         MapManager.currentMap.controlLevel["clickMC"].mouseEnabled = false;
         this.timerMap = new HashMap();
      }
      
      public function clickHandler() : void
      {
         if(this.flag == this.ATTACK)
         {
            SocketConnection.send(CommandID.TEAM_PK_ACTIVE_GET_ATTACK);
         }
         else
         {
            SocketConnection.send(CommandID.TEAM_PK_ACTIVE_GET_STONE);
         }
      }
      
      private function onPKActive(event:SocketEvent) : void
      {
         var data:ByteArray = event.data as ByteArray;
         this.flag = data.readUnsignedInt();
         this.update();
      }
      
      private function update() : void
      {
         trace("update------------------------>",this.flag);
         if(this.flag != this.NONE)
         {
            this.estradeMC["lightMC"].gotoAndPlay(2);
            MapManager.currentMap.controlLevel["clickMC"].mouseEnabled = true;
         }
         else
         {
            MapManager.currentMap.controlLevel["clickMC"].mouseEnabled = false;
         }
         DisplayUtil.removeForParent(this.attackMC,false);
         DisplayUtil.removeForParent(this.stoneMC,false);
         if(this.flag == this.ATTACK)
         {
            this.estradeMC.addChild(this.attackMC);
            this.attackMC.gotoAndPlay(2);
         }
         else if(this.flag == this.STONE)
         {
            this.estradeMC.addChild(this.stoneMC);
            this.stoneMC.gotoAndPlay(2);
         }
      }
      
      private function onNoteGetItem(event:SocketEvent) : void
      {
         var p:BasePeoleModel = null;
         var timerExt:TimerExt = null;
         var name:String = null;
         var data:ByteArray = event.data as ByteArray;
         var uid:uint = data.readUnsignedInt();
         var flag:uint = data.readUnsignedInt();
         var time:uint = data.readUnsignedInt();
         trace("-------------------------",uid,flag,time);
         if(flag != this.NONE)
         {
            MapManager.currentMap.controlLevel["clickMC"].mouseEnabled = false;
         }
         DisplayUtil.removeForParent(this.attackMC,false);
         DisplayUtil.removeForParent(this.stoneMC,false);
         if(flag == this.ATTACK)
         {
            p = UserManager.getUserModel(uid);
            if(Boolean(p))
            {
               TweenLite.to(p.skeleton.getSkeletonMC(),2,{
                  "scaleX":1.5,
                  "scaleY":1.5
               });
               if(!this.timerMap.containsKey(p))
               {
                  timerExt = new TimerExt(p);
                  this.timerMap.add(p,timerExt);
               }
               else
               {
                  timerExt = this.timerMap.getValue(p);
               }
               timerExt.start(time);
            }
         }
         else if(flag == this.STONE && uid == MainManager.actorID)
         {
            name = ItemXMLInfo.getName(400035);
            ItemInBagAlert.show(400035,TextFormatUtil.getRedTxt(name) + "已经放入了你的储存箱");
         }
      }
      
      public function destroy() : void
      {
         var i:TimerExt = null;
         for each(i in this.timerMap.getValues())
         {
            i.destroy();
         }
         this.timerMap.clear();
         this.timerMap = null;
         SocketConnection.removeCmdListener(CommandID.TEAM_PK_ACTIVE,this.onPKActive);
         SocketConnection.removeCmdListener(CommandID.TEAM_PK_ACTIVE_NOTE_GET_ITEM,this.onNoteGetItem);
      }
   }
}

import com.robot.core.mode.BasePeoleModel;
import flash.display.MovieClip;
import flash.events.TimerEvent;
import flash.utils.Timer;
import gs.TweenLite;
import org.taomee.utils.DisplayUtil;

class TimerExt
{
   private var p:BasePeoleModel;
   
   private var timer:Timer;
   
   private var flashMC:MovieClip;
   
   public function TimerExt(p:BasePeoleModel)
   {
      super();
      this.p = p;
      this.flashMC = new pk_flash_mc();
   }
   
   public function start(time:uint) : void
   {
      if(Boolean(this.p))
      {
         this.p.addChild(this.flashMC);
      }
      if(Boolean(this.timer))
      {
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
      }
      this.timer = new Timer(time * 1000,1);
      this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
      this.timer.start();
   }
   
   public function destroy() : void
   {
      if(Boolean(this.p))
      {
         try
         {
            TweenLite.to(this.p.skeleton.getSkeletonMC(),2,{
               "scaleX":1,
               "scaleY":1
            });
         }
         catch(e:Error)
         {
         }
      }
      if(Boolean(this.timer))
      {
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer = null;
      }
      DisplayUtil.removeForParent(this.flashMC,false);
   }
   
   private function onTimer(event:TimerEvent) : void
   {
      if(Boolean(this.p))
      {
         try
         {
            TweenLite.to(this.p.skeleton.getSkeletonMC(),2,{
               "scaleX":1,
               "scaleY":1
            });
         }
         catch(e:Error)
         {
         }
         DisplayUtil.removeForParent(this.flashMC,false);
      }
   }
}
