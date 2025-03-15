package com.robot.app.petbag.ui
{
   import com.robot.core.config.ClientConfig;
   import com.robot.core.config.xml.PetXMLInfo;
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.manager.TaskIconManager;
   import com.robot.core.manager.UIManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.DisplayUtil;
   import flash.filters.ColorMatrixFilter;
   import com.robot.core.config.xml.ShinyXMLInfo;
   public class PetBagListItem extends Sprite
   {
      private var _info:PetInfo;
      
      private var _mainUI:Sprite;
      
      private var _nameTxt:TextField;
      
      private var _barTxt:TextField;
      
      private var _lvTxt:TextField;
      
      private var _markMc:Sprite;
      
      private var _bgMc:MovieClip;
      
      private var _barMc:Sprite;
      
      private var _showMc:MovieClip;
      
      private var _selectFrame:int = 1;
      
      private var _bgY:MovieClip;
      
      private var _bgB:MovieClip;
      
      private var isDefault:Boolean = false;

      protected var filte:GlowFilter = new GlowFilter(3355443,0.9,3,3,3.1);

      public function PetBagListItem()
      {
         super();
         this._mainUI = UIManager.getSprite("PetListItemMc");
         this._nameTxt = this._mainUI["nameTxt"];
         this._barTxt = this._mainUI["barTxt"];
         this._lvTxt = this._mainUI["lvTxt"];
         this._markMc = this._mainUI["markMc"];
         this._barMc = this._mainUI["barMc"];
         this._mainUI["showMc"].visible = false;
         this._bgY = UIManager.getMovieClip("bgBtnY");
         this._bgB = UIManager.getMovieClip("bgBtnB");
         this._mainUI.addChildAt(this._bgY,0);
         this._mainUI.addChildAt(this._bgB,0);
         addChild(this._mainUI);
         mouseChildren = false;
         buttonMode = true;
         this._bgY.visible = false;
         this._bgMc = this._bgB;
         this._bgMc.gotoAndStop(this._selectFrame);
         this.init();
      }
      
      public function showClear() : void
      {
         var icon:MovieClip = null;
         icon = TaskIconManager.getIcon("Clear_MC") as MovieClip;
         this.addChild(icon);
         icon.x = 50;
         icon.y = 35;
         icon.addEventListener(Event.ENTER_FRAME,function(e:Event):void
         {
            if(icon.currentFrame == icon.totalFrames)
            {
               icon.removeEventListener(Event.ENTER_FRAME,arguments.callee);
               DisplayUtil.removeForParent(icon);
               icon = null;
            }
         });
      }
      
      public function get info() : PetInfo
      {
         return this._info;
      }
      
      public function set isSelect(b:Boolean) : void
      {
         if(b)
         {
            this._selectFrame = 2;
            this._bgMc.gotoAndStop(this._selectFrame);
            if(!this.isDefault)
            {
               this.filters = [new GlowFilter(16776960,1,15,15,2,1,true)];
            }
         }
         else
         {
            this._selectFrame = 1;
            this._bgMc.gotoAndStop(this._selectFrame);
            this.filters = [];
         }
      }
      
      public function get isSelect() : Boolean
      {
         return this._selectFrame == 2;
      }
      
      public function show(info:PetInfo) : void
      {
         this._info = info;
         if(this._info == null)
         {
            return;
         }
         this._nameTxt.visible = true;
         this._barTxt.visible = true;
         this._lvTxt.visible = true;
         this._markMc.visible = true;
         this._barMc.visible = true;
         this._nameTxt.text = PetXMLInfo.getName(this._info.id);
         this._barTxt.text = this._info.hp + "/" + this._info.maxHp;
         this._lvTxt.text = "lv." + this._info.level;
         this._markMc.width = this._info.hp / this._info.maxHp * this._barMc.width;
         if(Boolean(this._showMc))
         {
            DisplayUtil.removeForParent(this._showMc);
            this._showMc = null;
         }
         ResourceManager.getResource(ClientConfig.getPetSwfPath(this._info.skinID != 0 ? this._info.skinID : this._info.id),this.onShowComplete,"pet");
         this.addEvent();
      }
      
      public function hide() : void
      {
         this.removeEvent();
         this.init();
      }
      
      public function setDefault(b:Boolean) : void
      {
         this.isDefault = b;
         if(b)
         {
            if(this._bgMc != this._bgY)
            {
               this._bgMc.visible = false;
               this._bgMc = this._bgY;
               this._bgMc.visible = true;
               this._bgMc.gotoAndStop(this._selectFrame);
            }
         }
         else if(this._bgMc != this._bgB)
         {
            this._bgMc.visible = false;
            this._bgMc = this._bgB;
            this._bgMc.visible = true;
            this._bgMc.gotoAndStop(this._selectFrame);
         }
      }
      
      private function init() : void
      {
         this._info = null;
         this.setDefault(false);
         this.isSelect = false;
         this._nameTxt.visible = false;
         this._barTxt.visible = false;
         this._lvTxt.visible = false;
         this._markMc.visible = false;
         this._barMc.visible = false;
         if(Boolean(this._showMc))
         {
            DisplayUtil.removeForParent(this._showMc);
            this._showMc = null;
         }
      }
      
      private function addEvent() : void
      {
         addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      private function onOver(e:MouseEvent) : void
      {
         this._bgMc.gotoAndStop(this._selectFrame);
      }
      
      private function onOut(e:MouseEvent) : void
      {
         this._bgMc.gotoAndStop(this._selectFrame);
      }
      
      private function onShowComplete(o:DisplayObject) : void
      {
         this._showMc = o as MovieClip;
         if(Boolean(this._showMc))
         {
            DisplayUtil.stopAllMovieClip(this._showMc);
            this._showMc.scaleX = 0.8;
            this._showMc.scaleY = 0.8;
            this._showMc.x = 30;
            this._showMc.y = 50;
            if(_info.shiny != 0){
               var matrix:ColorMatrixFilter = null;
               var argArray:Array = ShinyXMLInfo.getShinyArray(_info.id);
               matrix = new ColorMatrixFilter(argArray);
               var glow:GlowFilter = null;
               var glowArray:Array = ShinyXMLInfo.getGlowArray(_info.id);
               glow = new GlowFilter(uint(glowArray[0]),int(glowArray[1]),int(glowArray[2]),int(glowArray[3]),int(glowArray[4]));
               this._showMc.filters = [ filte,glow,matrix ]
            }
            addChild(this._showMc);
         }
      }
   }
}

