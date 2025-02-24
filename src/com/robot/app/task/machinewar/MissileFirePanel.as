package com.robot.app.task.machinewar
{
   import com.robot.core.config.ClientConfig;
   import com.robot.core.event.ItemEvent;
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.info.userItem.SingleItemInfo;
   import com.robot.core.manager.ItemManager;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.newloader.MCLoader;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.effect.ColorFilter;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MissileFirePanel extends Sprite
   {
      private const PATH:String = "task/missilefire.swf";
      
      private var mainMC:MovieClip;
      
      private var closeBtn:SimpleButton;
      
      private var sendBtn:SimpleButton;
      
      private var canSend:Boolean;
      
      public function MissileFirePanel()
      {
         super();
      }
      
      public function show() : void
      {
         if(Boolean(this.mainMC))
         {
            this.init();
         }
         else
         {
            this.loadUI();
         }
      }
      
      private function loadUI() : void
      {
         var url:String = ClientConfig.getResPath(this.PATH);
         var mcloader:MCLoader = new MCLoader(url,LevelManager.appLevel,1,"正在打开发射系统程序");
         mcloader.addEventListener(MCLoadEvent.SUCCESS,this.onLoadSuccess);
         mcloader.doLoad();
      }
      
      private function onLoadSuccess(event:MCLoadEvent) : void
      {
         var cls:Class;
         var mcloader:MCLoader = event.currentTarget as MCLoader;
         mcloader.removeEventListener(MCLoadEvent.SUCCESS,this.onLoadSuccess);
         cls = event.getApplicationDomain().getDefinition("Main_Panel") as Class;
         this.mainMC = new cls() as MovieClip;
         this.closeBtn = this.mainMC["close_btn"];
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.close);
         this.sendBtn = this.mainMC["send_bomrb"];
         this.sendBtn.addEventListener(MouseEvent.CLICK,this.sendHandler);
         mcloader.clear();
         ItemManager.addEventListener(ItemEvent.COLLECTION_LIST,function(event:ItemEvent):void
         {
            var i:uint = 0;
            var num:uint = 0;
            ItemManager.removeEventListener(ItemEvent.COLLECTION_LIST,arguments.callee);
            var info:SingleItemInfo = ItemManager.getInfo(400008);
            if(Boolean(info))
            {
               num = uint(info.itemNum);
               if(num >= 5)
               {
                  canSend = true;
               }
               else
               {
                  for(i = uint(num + 1); i < 6; i++)
                  {
                     mainMC["energy" + i].filters = [ColorFilter.setGrayscale()];
                  }
               }
            }
            else
            {
               canSend = false;
               for(i = 1; i < 6; i++)
               {
                  mainMC["energy" + i].filters = [ColorFilter.setGrayscale()];
               }
            }
         });
         ItemManager.getCollection();
         this.init();
      }
      
      private function init() : void
      {
         this.addChild(this.mainMC);
         DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER);
         LevelManager.appLevel.addChild(this);
      }
      
      private function close(event:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this);
      }
      
      private function sendHandler(event:MouseEvent) : void
      {
         if(this.canSend)
         {
            this.mainMC.gotoAndStop(2);
            LevelManager.closeMouseEvent();
            this.mainMC.addEventListener(Event.ENTER_FRAME,function(e:Event):void
            {
               var mc:MovieClip = mainMC["loading"];
               if(Boolean(mc))
               {
                  mainMC.removeEventListener(Event.ENTER_FRAME,arguments.callee);
                  mc.addEventListener(Event.ENTER_FRAME,onLoadingFrameHandler);
               }
            });
         }
         else
         {
            Alarm.show("很抱歉您目前还没有<font color=\'#ff0000\'>5颗电容球</font>，不能启动导弹发射装置。");
         }
      }
      
      private function onLoadingFrameHandler(e:Event) : void
      {
         if(this.mainMC["loading"].totalFrames == this.mainMC["loading"].currentFrame)
         {
            this.mainMC["loading"].removeEventListener(Event.ENTER_FRAME,this.onLoadingFrameHandler);
            LevelManager.openMouseEvent();
            this.dispatchEvent(new Event("canSend"));
            this.close(null);
         }
      }
      
      private function loadItem(arr:Array) : void
      {
      }
   }
}

