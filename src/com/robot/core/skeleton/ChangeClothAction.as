package com.robot.core.skeleton
{
   import com.robot.core.info.clothInfo.PeopleItemInfo;
   import com.robot.core.info.item.ClothInfo;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.mode.ISkeletonSprite;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.DisplayUtil;
   
   public class ChangeClothAction
   {
      private static const B_S:Number = 0.2;
      
      private static const S_S:Number = 1;
      
      public static const GLOW_1:Array = [new GlowFilter(16777215,1,10,10,0.8),new GlowFilter(16776960,1,B_S,B_S,S_S)];
      
      public static const GLOW_2:Array = [new GlowFilter(16777215,1,10,10,0.8),new GlowFilter(16711680,1,B_S,B_S,S_S)];
      
      protected var clothID:int = 0;
      
      protected var clothLevel:uint = 0;
      
      protected var people:ISkeletonSprite;
      
      protected var clothSWF:MovieClip;
      
      protected var isLoaded:Boolean = false;
      
      protected var offsetPoint:Point;
      
      protected var container:Sprite;
      
      protected var type:String;
      
      protected var model:uint;
      
      private var _clothURL:String = "";
      
      public function ChangeClothAction(people:ISkeletonSprite, container:Sprite, type:String, model:uint)
      {
         super();
         this.model = model;
         this.type = type;
         this.people = people;
         this.container = container;
         this.takeOffCloth();
      }
      
      public function changeCloth(clothInfo:PeopleItemInfo) : void
      {
         if(ClothInfo.getItemInfo(clothInfo.id).type == "bg")
         {
            return;
         }
         this.clothID = clothInfo.id;
         this.clothLevel = clothInfo.level;
         this.beginLoad();
      }
      
      public function changeClothByPath(clothID:int, path:String) : void
      {
         this.clothID = clothID;
         this.beginLoad(path);
      }
      
      public function addChildCloth(mc:MovieClip, container:Sprite) : void
      {
         this.clothSWF = mc;
         this.container = container;
         this.clothSWF.cacheAsBitmap = true;
         if(Boolean(this.people))
         {
            this.clothSWF.gotoAndStop(this.people.direction);
         }
         if(Boolean(container))
         {
            container.addChild(this.clothSWF);
         }
         this.isLoaded = true;
      }
      
      public function takeOffCloth() : void
      {
         if(this.type == SkeletonClothPreview.FLAG_CLOTH)
         {
            return;
         }
         if(Boolean(this.clothSWF))
         {
            DisplayUtil.removeForParent(this.clothSWF);
            this.clothSWF = null;
            this.isLoaded = false;
            this.clothID = 0;
         }
         if(this.type == ClothPreview.FLAG_HEAD)
         {
            this.changeCloth(new PeopleItemInfo(ClothInfo.DEFAULT_HEAD));
         }
         else if(this.type == ClothPreview.FLAG_WAIST)
         {
            this.changeCloth(new PeopleItemInfo(ClothInfo.DEFAULT_WAIST));
         }
         else if(this.type == ClothPreview.FLAG_FOOT)
         {
            this.changeCloth(new PeopleItemInfo(ClothInfo.DEFAULT_FOOT));
         }
      }
      
      public function changeDir(str:String) : void
      {
         if(this.isLoaded)
         {
            this.clothSWF.gotoAndStop(str);
         }
      }
      
      public function specialAction(peopleMode:BasePeoleModel, id:uint, isCheckID:Boolean = true) : void
      {
         if(Boolean(this.clothSWF))
         {
            this.clothSWF.gotoAndStop(BasePeoleModel.SPECIAL_ACTION);
         }
         if(id == this.clothID && isCheckID)
         {
            this.clothSWF.addEventListener(Event.ENTER_FRAME,function():void
            {
               var color:MovieClip = null;
               var mc:MovieClip = clothSWF.getChildByName("bodyMC") as MovieClip;
               if(Boolean(mc))
               {
                  color = mc["colorMC"];
                  DisplayUtil.FillColor(color,peopleMode.info.color);
                  clothSWF.removeEventListener(Event.ENTER_FRAME,arguments.callee);
               }
            });
         }
      }
      
      public function goStart() : void
      {
         var mc:MovieClip = null;
         if(Boolean(this.clothSWF))
         {
            mc = this.clothSWF.getChildAt(0) as MovieClip;
            if(Boolean(mc))
            {
               mc.gotoAndPlay(2);
            }
         }
      }
      
      public function goOver() : void
      {
         var mc:MovieClip = null;
         if(Boolean(this.clothSWF))
         {
            mc = this.clothSWF.getChildAt(0) as MovieClip;
            if(Boolean(mc))
            {
               mc.gotoAndStop(1);
            }
         }
      }
      
      public function goEnterFrame() : void
      {
         var mc:MovieClip = null;
         if(Boolean(this.clothSWF))
         {
            mc = this.clothSWF.getChildAt(0) as MovieClip;
            if(Boolean(mc))
            {
               if(mc.currentFrame == 1)
               {
                  mc.gotoAndPlay(2);
               }
            }
         }
      }
      
      protected function beginLoad(path:String = "") : void
      {
         if(this._clothURL != "")
         {
            ResourceManager.cancel(this._clothURL,this.onLoadCloth);
         }
         if(path == "")
         {
            switch(this.model)
            {
               case ClothPreview.MODEL_PEOPLE:
                  this._clothURL = ClothInfo.getItemInfo(this.clothID).getUrl(this.clothLevel);
                  break;
               case ClothPreview.MODEL_SHOW:
                  this._clothURL = ClothInfo.getItemInfo(this.clothID).getPrevUrl(this.clothLevel);
                  break;
               default:
                  this._clothURL = ClothInfo.getItemInfo(this.clothID).getUrl(this.clothLevel);
            }
         }
         else
         {
            this._clothURL = path;
         }
         ResourceManager.getResource(this._clothURL,this.onLoadCloth);
      }
      
      private function onLoadCloth(obj:DisplayObject) : void
      {
         if(Boolean(this.clothSWF))
         {
            this.clothSWF.removeEventListener(MouseEvent.CLICK,this.unloadCloth);
            DisplayUtil.removeForParent(this.clothSWF);
         }
         this.clothSWF = obj as MovieClip;
         this.clothSWF.cacheAsBitmap = true;
         this.clothSWF.mouseChildren = false;
         this.clothSWF.addEventListener(MouseEvent.CLICK,this.unloadCloth);
         this.clothSWF.addEventListener(MouseEvent.MOUSE_OVER,this.onClothOver);
         this.clothSWF.addEventListener(MouseEvent.MOUSE_OUT,this.onClothOut);
         if(Boolean(this.people))
         {
            this.clothSWF.gotoAndStop(this.people.direction);
         }
         if(Boolean(this.container))
         {
            this.container.addChild(this.clothSWF);
         }
         this.isLoaded = true;
      }
      
      protected function unloadCloth(e:MouseEvent) : void
      {
      }
      
      protected function onClothOver(e:MouseEvent) : void
      {
         (e.currentTarget as DisplayObject).filters = [new GlowFilter()];
      }
      
      protected function onClothOut(e:MouseEvent) : void
      {
         (e.currentTarget as DisplayObject).filters = [];
      }
      
      public function getClothLevel() : uint
      {
         return this.clothLevel;
      }
      
      public function getClothID() : int
      {
         var id:uint = 0;
         if(this.clothID == ClothInfo.DEFAULT_FOOT || this.clothID == ClothInfo.DEFAULT_HEAD || this.clothID == ClothInfo.DEFAULT_WAIST)
         {
            id = 0;
         }
         else
         {
            id = uint(this.clothID);
         }
         return id;
      }
   }
}

