package com.robot.app.sceneInteraction
{
   import com.robot.core.manager.MapManager;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class ShiperRoom
   {
      private static var firTVMC:MovieClip;
      
      private static var secTVMC:MovieClip;
      
      private static var redBtn:SimpleButton;
      
      private static var blueBtn:SimpleButton;
      
      private static var greenBtn:SimpleButton;
      
      private static var yellowBtn:SimpleButton;
      
      private static var npcMc:MovieClip;
      
      private static var isGreen:Boolean;
      
      private static var isYellow:Boolean;
      
      private static var isBlue:Boolean;
      
      private static var colorMC:MovieClip;
      
      public function ShiperRoom()
      {
         super();
      }
      
      public static function start() : void
      {
         var startBtn:SimpleButton = MapManager.currentMap.controlLevel["startBtn"] as SimpleButton;
         startBtn.addEventListener(MouseEvent.CLICK,showColorPanel);
         firTVMC = MapManager.currentMap.controlLevel["firstTV"] as MovieClip;
         firTVMC.addEventListener(MouseEvent.MOUSE_OVER,onOver);
         firTVMC.buttonMode = true;
         firTVMC.mouseChildren = false;
         firTVMC.addEventListener(MouseEvent.MOUSE_OUT,onOut1);
         DisplayUtil.stopAllMovieClip(firTVMC);
         var ftvBtn:SimpleButton = MapManager.currentMap.controlLevel["firTVBtn"] as SimpleButton;
         ftvBtn.addEventListener(MouseEvent.CLICK,showFTV);
         secTVMC = MapManager.currentMap.controlLevel["tv2"] as MovieClip;
         secTVMC.buttonMode = true;
         DisplayUtil.stopAllMovieClip(secTVMC);
         secTVMC.mouseChildren = false;
         secTVMC.addEventListener(MouseEvent.MOUSE_OVER,onOver2);
         secTVMC.addEventListener(MouseEvent.MOUSE_OUT,onOut2);
         var secBtn:SimpleButton = MapManager.currentMap.controlLevel["secTVBtn"] as SimpleButton;
         secBtn.addEventListener(MouseEvent.CLICK,showSTV);
      }
      
      public static function destroy() : void
      {
         firTVMC = null;
         secTVMC = null;
         redBtn = null;
         blueBtn = null;
         greenBtn = null;
         yellowBtn = null;
         npcMc = null;
      }
      
      private static function showColorPanel(e:MouseEvent) : void
      {
         colorMC.visible = !colorMC.visible;
         MapManager.currentMap.controlLevel["startBtn"].mouseEnabled = false;
      }
      
      private static function onRed(e:MouseEvent) : void
      {
         if(isBlue)
         {
            isBlue = false;
         }
      }
      
      private static function onOver(e:MouseEvent) : void
      {
         firTVMC.gotoAndStop(2);
      }
      
      private static function onOver2(e:MouseEvent) : void
      {
         secTVMC.gotoAndStop(2);
      }
      
      private static function onOut2(e:MouseEvent) : void
      {
         secTVMC.gotoAndStop(1);
         secTVMC.addEventListener(Event.ENTER_FRAME,onLeft2);
      }
      
      private static function onOut1(e:MouseEvent) : void
      {
         firTVMC.gotoAndStop(1);
         firTVMC.addEventListener(Event.ENTER_FRAME,onLeft);
      }
      
      private static function onLeft2(e:Event) : void
      {
         var up:MovieClip = null;
         if(secTVMC.currentFrame == 1)
         {
            up = secTVMC.getChildByName("up") as MovieClip;
            if(Boolean(up))
            {
               secTVMC.removeEventListener(Event.ENTER_FRAME,onLeft2);
               up.gotoAndPlay(18);
            }
         }
      }
      
      private static function onLeft(e:Event) : void
      {
         var up:MovieClip = null;
         if(firTVMC.currentFrame == 1)
         {
            up = firTVMC.getChildByName("up") as MovieClip;
            if(Boolean(up))
            {
               firTVMC.removeEventListener(Event.ENTER_FRAME,onLeft);
               up.gotoAndPlay(10);
            }
         }
      }
      
      private static function onBlue(e:MouseEvent) : void
      {
         if(isYellow)
         {
            isBlue = true;
            isYellow = false;
            isGreen = false;
         }
      }
      
      private static function onGreen(e:MouseEvent) : void
      {
         isGreen = true;
         isYellow = false;
         isBlue = false;
      }
      
      private static function onYellow(e:MouseEvent) : void
      {
         if(isGreen)
         {
            isYellow = true;
            isGreen = false;
            isBlue = false;
         }
      }
      
      private static function showFTV(e:MouseEvent) : void
      {
         firTVMC.gotoAndStop(1);
         firTVMC.addEventListener(Event.ENTER_FRAME,onEnterShow);
      }
      
      private static function showSTV(e:MouseEvent) : void
      {
         secTVMC.gotoAndStop(1);
         secTVMC.addEventListener(Event.ENTER_FRAME,onEnterShow2);
      }
      
      private static function onEnterShow(e:Event) : void
      {
         var up:MovieClip = null;
         if(firTVMC.currentFrame == 1)
         {
            up = firTVMC.getChildByName("up") as MovieClip;
            if(Boolean(up))
            {
               firTVMC.removeEventListener(Event.ENTER_FRAME,onEnterShow);
               up.gotoAndPlay(2);
            }
         }
      }
      
      private static function onEnterShow2(e:Event) : void
      {
         var up:MovieClip = null;
         if(secTVMC.currentFrame == 1)
         {
            up = secTVMC.getChildByName("up") as MovieClip;
            if(Boolean(up))
            {
               secTVMC.removeEventListener(Event.ENTER_FRAME,onEnterShow2);
               up.gotoAndPlay(2);
            }
         }
      }
   }
}

