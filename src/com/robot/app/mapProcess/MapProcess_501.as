package com.robot.app.mapProcess
{
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_501 extends BaseMapProcess
   {
      private var shootMC:MovieClip;
      
      private var mirrorUpMC:MovieClip;
      
      private var mirrorDownMC:MovieClip;
      
      private var bridgeMC:MovieClip;
      
      private var pillarMC:MovieClip;
      
      private var clickCount:uint = 0;
      
      public function MapProcess_501()
      {
         super();
      }
      
      override protected function init() : void
      {
         var btn:SimpleButton = null;
         this.shootMC = conLevel["shootMC"];
         this.shootMC.buttonMode = true;
         this.shootMC.addEventListener(MouseEvent.CLICK,this.onShootMCHandler);
         this.shootMC.addEventListener(MouseEvent.ROLL_OVER,this.onShootOverHandler);
         this.mirrorUpMC = conLevel["mirrorUpMC"];
         this.mirrorUpMC.buttonMode = true;
         this.mirrorUpMC.addEventListener(MouseEvent.CLICK,this.onMirrorMCHandler);
         this.mirrorDownMC = conLevel["mirrorDownMC"];
         this.mirrorDownMC.buttonMode = true;
         this.mirrorDownMC.addEventListener(MouseEvent.CLICK,this.onMirrorMCHandler);
         this.bridgeMC = conLevel["bridgeMC"];
         this.pillarMC = animatorLevel["pillarMC"];
         for(var i:uint = 1; i < 5; i++)
         {
            btn = conLevel["btn" + i];
            btn.addEventListener(MouseEvent.CLICK,this.onBtnClickHandler);
         }
         conLevel["door_1"].mouseEnabled = false;
      }
      
      override public function destroy() : void
      {
         var btn:SimpleButton = null;
         for(var i:uint = 1; i < 5; i++)
         {
            btn = conLevel["btn" + i];
            btn.removeEventListener(MouseEvent.CLICK,this.onBtnClickHandler);
         }
         this.shootMC.removeEventListener(MouseEvent.CLICK,this.onShootMCHandler);
         this.shootMC.removeEventListener(MouseEvent.ROLL_OVER,this.onShootOverHandler);
         this.mirrorUpMC.removeEventListener(MouseEvent.CLICK,this.onMirrorMCHandler);
         this.mirrorDownMC.removeEventListener(MouseEvent.CLICK,this.onMirrorMCHandler);
         if(this.mirrorDownMC.hasEventListener(Event.ENTER_FRAME))
         {
            this.mirrorDownMC.removeEventListener(Event.ENTER_FRAME,this.onMirrorDownMCFrameHandler);
         }
         if(this.mirrorUpMC.hasEventListener(Event.ENTER_FRAME))
         {
            this.mirrorUpMC.removeEventListener(Event.ENTER_FRAME,this.onMirrorUpMCFrameHandler);
         }
         if(this.pillarMC.hasEventListener(Event.ENTER_FRAME))
         {
            this.pillarMC.removeEventListener(Event.ENTER_FRAME,this.onPillarMCFrameHandler);
         }
         if(this.shootMC.hasEventListener(Event.ENTER_FRAME))
         {
            this.shootMC.removeEventListener(Event.ENTER_FRAME,this.onShootMCFrameHandler);
         }
         this.shootMC = null;
         this.mirrorUpMC = null;
         this.mirrorDownMC = null;
         this.bridgeMC = null;
         this.pillarMC = null;
      }
      
      private function onBtnClickHandler(e:MouseEvent) : void
      {
         var btn:SimpleButton = e.currentTarget as SimpleButton;
         btn.mouseEnabled = false;
         conLevel["light_" + uint(btn.name.substr(-1,1))].visible = false;
         ++this.clickCount;
         this.checkClickCount();
      }
      
      private function checkClickCount() : void
      {
         if(this.clickCount >= 4)
         {
            conLevel["door_1"].mouseEnabled = true;
         }
      }
      
      private function onPillarMCFrameHandler(e:Event) : void
      {
         if(this.pillarMC.currentFrame == this.pillarMC.totalFrames)
         {
            this.pillarMC.removeEventListener(Event.ENTER_FRAME,this.onPillarMCFrameHandler);
            this.bridgeMC.gotoAndStop(4);
            DisplayUtil.removeForParent(typeLevel["maskMC"]);
            MapManager.currentMap.makeMapArray();
         }
      }
      
      private function onMirrorDownMCFrameHandler(e:Event) : void
      {
         if(this.mirrorDownMC.currentFrame == this.mirrorDownMC.totalFrames)
         {
            this.mirrorDownMC.removeEventListener(Event.ENTER_FRAME,this.onMirrorDownMCFrameHandler);
            this.pillarMC.gotoAndPlay(2);
            this.pillarMC.addEventListener(Event.ENTER_FRAME,this.onPillarMCFrameHandler);
            trace("ok");
         }
      }
      
      private function onMirrorUpMCFrameHandler(e:Event) : void
      {
         if(this.mirrorUpMC.currentFrame == this.mirrorUpMC.totalFrames)
         {
            this.mirrorUpMC.removeEventListener(Event.ENTER_FRAME,this.onMirrorUpMCFrameHandler);
            if(this.mirrorDownMC.currentLabel == "up" || this.mirrorDownMC.currentLabel == "upstate")
            {
               this.mirrorDownMC.gotoAndPlay("lightup");
               return;
            }
            if(this.mirrorDownMC.currentLabel == "horiz" || this.mirrorDownMC.currentLabel == "horizstate")
            {
               this.mirrorDownMC.gotoAndPlay("lighthoriz");
               return;
            }
            this.mirrorDownMC.gotoAndPlay("lightdown");
            this.mirrorDownMC.addEventListener(Event.ENTER_FRAME,this.onMirrorDownMCFrameHandler);
         }
      }
      
      private function onShootMCFrameHandler(e:Event) : void
      {
         if(this.shootMC.currentFrame == this.shootMC.totalFrames)
         {
            this.shootMC.removeEventListener(Event.ENTER_FRAME,this.onShootMCFrameHandler);
            if(this.mirrorUpMC.currentLabel == "up" || this.mirrorUpMC.currentLabel == "upstate")
            {
               this.mirrorUpMC.gotoAndPlay("lightup");
               return;
            }
            if(this.mirrorUpMC.currentLabel == "horiz" || this.mirrorUpMC.currentLabel == "horizstate")
            {
               this.mirrorUpMC.gotoAndPlay("lighthoriz");
               return;
            }
            this.mirrorUpMC.gotoAndPlay("lightdown");
            this.mirrorUpMC.addEventListener(Event.ENTER_FRAME,this.onMirrorUpMCFrameHandler);
         }
      }
      
      private function onShootMCHandler(e:MouseEvent) : void
      {
         this.shootMC.gotoAndPlay("fire");
         this.shootMC.addEventListener(Event.ENTER_FRAME,this.onShootMCFrameHandler);
      }
      
      private function onShootOverHandler(e:MouseEvent) : void
      {
         this.shootMC.gotoAndPlay(1);
      }
      
      private function onMirrorMCHandler(e:MouseEvent) : void
      {
         var mc:MovieClip = e.currentTarget as MovieClip;
         switch(mc.currentLabel)
         {
            case "up":
               mc.gotoAndStop("horiz");
               break;
            case "horiz":
               mc.gotoAndStop("down");
               break;
            case "down":
               mc.gotoAndStop("up");
               break;
            case "upstate":
               mc.gotoAndStop("horiz");
               break;
            case "horizstate":
               mc.gotoAndStop("down");
               break;
            case "downstate":
               mc.gotoAndStop("up");
         }
      }
      
      private function onBridgeMCHandler(e:MouseEvent) : void
      {
      }
   }
}

