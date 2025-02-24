package com.robot.core.ui.alert
{
   import com.robot.core.config.ClientConfig;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.UIManager;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class PetInBagAlert
   {
      public function PetInBagAlert()
      {
         super();
      }
      
      public static function show(id:uint, str:String, par:DisplayObjectContainer = null, fun:Function = null) : void
      {
         var bgmc:Sprite;
         var mainUI:Sprite = null;
         var applyBtn:SimpleButton = null;
         var onApply:Function = null;
         var onLoad:Function = null;
         onApply = function(event:MouseEvent):void
         {
            if(fun != null)
            {
               fun();
            }
            LevelManager.openMouseEvent();
            applyBtn.removeEventListener(MouseEvent.CLICK,onApply);
            ResourceManager.cancel(ClientConfig.getPetSwfPath(id),onLoad);
            DisplayUtil.removeForParent(mainUI);
            txt = null;
            applyBtn = null;
            mainUI = null;
         };
         onLoad = function(o:DisplayObject):void
         {
            var _obj:MovieClip = null;
            _obj = o as MovieClip;
            DisplayUtil.stopAllMovieClip(_obj);
            mainUI.addChild(_obj);
            _obj.x = 100;
            _obj.y = 100;
         };
         mainUI = UIManager.getSprite("UI_PetSwitchAlert");
         var txt:TextField = mainUI["txt"];
         txt.htmlText = str;
         bgmc = mainUI["bgMc"];
         bgmc.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            mainUI.startDrag();
         });
         bgmc.addEventListener(MouseEvent.MOUSE_UP,function():void
         {
            mainUI.stopDrag();
         });
         if(Boolean(par))
         {
            par.addChild(mainUI);
         }
         else
         {
            LevelManager.topLevel.addChild(mainUI);
         }
         DisplayUtil.align(mainUI,null,AlignType.MIDDLE_CENTER);
         LevelManager.closeMouseEvent();
         applyBtn = mainUI["applyBtn"];
         applyBtn.addEventListener(MouseEvent.CLICK,onApply);
         ResourceManager.getResource(ClientConfig.getPetSwfPath(id),onLoad,"pet");
      }
   }
}

