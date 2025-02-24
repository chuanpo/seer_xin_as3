package com.robot.core.skeleton
{
   import com.robot.core.info.clothInfo.PeopleItemInfo;
   import com.robot.core.info.item.ClothInfo;
   import com.robot.core.mode.ISkeletonSprite;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.DisplayUtil;
   
   public class ClothPreview
   {
      public static const MODEL_PEOPLE:uint = 0;
      
      public static const MODEL_SHOW:uint = 1;
      
      public static const FLAG_TOP:String = "top";
      
      public static const FLAG_HEAD:String = "head";
      
      public static const FLAG_EYE:String = "eye";
      
      public static const FLAG_HAND:String = "hand";
      
      public static const FLAG_WAIST:String = "waist";
      
      public static const FLAG_DECORATOR:String = "decorator";
      
      public static const FLAG_FOOT:String = "foot";
      
      public static const FLAG_BG:String = "bg";
      
      public static const FLAG_COLOR:String = "color";
      
      protected var skeletonMC:MovieClip;
      
      protected var composeMC:Sprite;
      
      protected var colorMC:MovieClip;
      
      protected var doodleMC:MovieClip;
      
      protected var people:ISkeletonSprite;
      
      protected var mcObj:Object;
      
      protected var changeClothActObj:Object;
      
      protected var flagArray:Array;
      
      protected var model:uint;
      
      public function ClothPreview(mc:Sprite, people:ISkeletonSprite = null, model:uint = 0)
      {
         var i:String = null;
         this.mcObj = {};
         this.changeClothActObj = {};
         super();
         this.model = model;
         this.people = people;
         this.flagArray = this.getFlagArray();
         this.composeMC = mc;
         this.colorMC = this.composeMC[FLAG_COLOR];
         this.colorMC.gotoAndStop(1);
         this.doodleMC = this.composeMC[FLAG_DECORATOR];
         this.doodleMC.gotoAndStop(1);
         for each(i in this.flagArray)
         {
            this.mcObj[i] = this.composeMC[i];
         }
         this.initChangeCloth();
      }
      
      public function getClothArray() : Array
      {
         var i:ChangeClothAction = null;
         var array:Array = [];
         for each(i in this.changeClothActObj)
         {
            if(i.getClothID() > 0)
            {
               array.push(new PeopleItemInfo(i.getClothID(),i.getClothLevel()));
            }
         }
         return array;
      }
      
      public function getClothIDs() : Array
      {
         var i:PeopleItemInfo = null;
         var arr:Array = [];
         var array:Array = this.getClothArray();
         for each(i in array)
         {
            arr.push(i.id);
         }
         return arr;
      }
      
      public function getClothStr() : String
      {
         var i:PeopleItemInfo = null;
         var array:Array = this.getClothArray();
         var arr:Array = [];
         for each(i in array)
         {
            arr.push(i.id);
         }
         return arr.sort().join(",");
      }
      
      public function takeOffCloth() : void
      {
         var i:ChangeClothAction = null;
         for each(i in this.changeClothActObj)
         {
            i.takeOffCloth();
         }
      }
      
      protected function getFlagArray() : Array
      {
         return new Array(FLAG_TOP,FLAG_HEAD,FLAG_EYE,FLAG_HAND,FLAG_WAIST,FLAG_DECORATOR,FLAG_FOOT,FLAG_BG);
      }
      
      public function changeCloth(clothArray:Array) : void
      {
         var i:PeopleItemInfo = null;
         var name:String = null;
         var changeAct:ChangeClothAction = null;
         for each(i in clothArray)
         {
            name = ClothInfo.getItemInfo(i.id).type;
            changeAct = this.changeClothActObj[name];
            changeAct.changeCloth(i);
         }
      }
      
      public function changeColor(color:uint, isTexture:Boolean = true) : void
      {
         DisplayUtil.FillColor(this.colorMC,color);
         if(isTexture)
         {
            DisplayUtil.removeAllChild(this.doodleMC);
         }
      }
      
      public function changeDoodle(url:String) : void
      {
         DisplayUtil.removeAllChild(this.doodleMC);
         ResourceManager.getResource(url,function(obj:DisplayObject):void
         {
            (obj as MovieClip).gotoAndStop(people.direction);
            doodleMC.addChild(obj);
         });
      }
      
      protected function initChangeCloth() : void
      {
         var i:String = null;
         var changeAct:ChangeClothAction = null;
         for each(i in this.flagArray)
         {
            changeAct = new ChangeClothAction(this.people,this.mcObj[i],i,this.model);
            this.changeClothActObj[i] = changeAct;
         }
      }
      
      public function destroy() : void
      {
         this.skeletonMC = null;
         this.composeMC = null;
         this.colorMC = null;
         this.doodleMC = null;
         this.people = null;
         this.mcObj = null;
         this.changeClothActObj = null;
      }
   }
}

