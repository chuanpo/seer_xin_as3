package com.robot.core.animate
{
   import com.robot.core.SoundManager;
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.newloader.MCLoader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.system.ApplicationDomain;
   import org.taomee.utils.DisplayUtil;
   
   public class AnimateManager
   {
      private static var url:String;
      
      private static var name:String;
      
      private static var soundName:String;
      
      private static var func:Function;
      
      private static var mcloader:MCLoader;
      
      private static var soundChal:SoundChannel;
      
      private static var frameFunc:Function;
      
      public static const MC_NOT_FIND:String = "mcIsNotFind";
      
      public function AnimateManager()
      {
         super();
      }
      
      public static function playFullScreenAnimate(swfUrl:String = "", fuc:Function = null, mcName:String = null, sudName:String = null) : void
      {
         url = swfUrl;
         name = mcName;
         soundName = sudName;
         func = fuc;
         if(swfUrl != "" && swfUrl != null)
         {
            if(Boolean(mcloader))
            {
               mcloader.clear();
               mcloader = null;
            }
            mcloader = new MCLoader(url,LevelManager.appLevel,1,"正在加载动画..");
            mcloader.addEventListener(MCLoadEvent.SUCCESS,onLoadAnimateSuccess);
            mcloader.doLoad(url);
            return;
         }
         throw new Error("加载的动画路径不对哟!");
      }
      
      private static function onLoadAnimateSuccess(evt:MCLoadEvent) : void
      {
         var app_0:ApplicationDomain = null;
         var cls_0:* = undefined;
         var sound:Sound = null;
         var app:ApplicationDomain = null;
         var cls:* = undefined;
         var mc:MovieClip = null;
         var m:MovieClip = null;
         LevelManager.closeMouseEvent();
         SoundManager.stopSound();
         mcloader.removeEventListener(MCLoadEvent.SUCCESS,onLoadAnimateSuccess);
         if(soundName != "" && soundName != null)
         {
            app_0 = evt.getApplicationDomain();
            cls_0 = app_0.getDefinition(soundName);
            sound = new cls_0() as Sound;
            if(Boolean(soundChal))
            {
               soundChal.stop();
               soundChal = null;
            }
            soundChal = sound.play(10);
         }
         if(name != "" && name != null)
         {
            app = evt.getApplicationDomain();
            cls = app.getDefinition(name);
            mc = new cls() as MovieClip;
            if(mc == null)
            {
               throw new Error("加载的动画出错!");
            }
            MainManager.getStage().addChild(mc);
            playMovieClip(mc);
         }
         else
         {
            m = evt.getContent() as MovieClip;
            MainManager.getStage().addChild(m);
            playMovieClip(m);
         }
      }
      
      private static function playMovieClip(mc:MovieClip) : void
      {
         mc.gotoAndPlay(2);
         mc.addEventListener(Event.ENTER_FRAME,function(evt:Event):void
         {
            if(mc.currentFrame == mc.totalFrames)
            {
               mc.removeEventListener(Event.ENTER_FRAME,arguments.callee);
               DisplayUtil.removeForParent(mc);
               mc = null;
               SoundManager.playSound();
               LevelManager.openMouseEvent();
               if(Boolean(soundChal))
               {
                  soundChal.stop();
               }
               url = "";
               name = "";
               soundName = "";
               if(func != null)
               {
                  func();
               }
            }
         });
      }
      
      public static function playMcAnimate(mc:MovieClip, frame:uint = 0, name:String = "", func:Function = null) : void
      {
         frameFunc = func;
         if(func == null)
         {
            throw new Error("动画播放回调函数不能为null");
         }
         if(frame == 0 || name == "" || name == null)
         {
            playFrameMC(mc);
         }
         else
         {
            mc.gotoAndStop(frame);
            LevelManager.closeMouseEvent();
            mc.addEventListener(Event.ENTER_FRAME,function():void
            {
               var frameMC:MovieClip = mc[name] as MovieClip;
               if(Boolean(frameMC))
               {
                  mc.removeEventListener(Event.ENTER_FRAME,arguments.callee);
                  playFrameMC(frameMC);
               }
            });
         }
      }
      
      private static function playFrameMC(frameMC:MovieClip) : void
      {
         if(Boolean(frameMC))
         {
            frameMC.gotoAndPlay(2);
            frameMC.addEventListener(Event.ENTER_FRAME,function(evt:Event):void
            {
               if(frameMC.currentFrame == frameMC.totalFrames)
               {
                  frameMC.removeEventListener(Event.ENTER_FRAME,arguments.callee);
                  LevelManager.openMouseEvent();
                  frameFunc();
               }
            });
         }
      }
   }
}

