package com.robot.core.skeleton
{
   import com.robot.core.info.item.ClothData;
   import com.robot.core.info.item.ClothInfo;
   import com.robot.core.manager.UIManager;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.mode.ISkeletonSprite;
   import com.robot.core.utils.Direction;
   import flash.display.MovieClip;
   
   public class SkeletonClothPreview extends ClothPreview
   {
      public static var FLAG_CLOTH:String = "cloth";
      
      private var defaultCloth:MovieClip;
      
      public function SkeletonClothPreview(mc:MovieClip, people:ISkeletonSprite = null)
      {
         super(mc,people);
      }
      
      override protected function getFlagArray() : Array
      {
         return new Array(FLAG_TOP,FLAG_HEAD,FLAG_EYE,FLAG_HAND,FLAG_WAIST,FLAG_DECORATOR,FLAG_FOOT,FLAG_BG,FLAG_CLOTH);
      }
      
      public function changeDefaultCloth() : void
      {
         this.defaultCloth = UIManager.getMovieClip("defaultCloth");
         var act:ChangeClothAction = changeClothActObj[FLAG_CLOTH];
         act.addChildCloth(this.defaultCloth,composeMC[FLAG_CLOTH]);
      }
      
      public function play() : void
      {
         var i:ChangeClothAction = null;
         var dmc:MovieClip = null;
         var d2mc:MovieClip = null;
         var mc:MovieClip = colorMC.getChildAt(0) as MovieClip;
         if(Boolean(mc))
         {
            mc.gotoAndPlay(2);
         }
         if(doodleMC.numChildren > 0)
         {
            dmc = doodleMC.getChildAt(0) as MovieClip;
            if(Boolean(dmc))
            {
               d2mc = dmc.getChildAt(0) as MovieClip;
               if(Boolean(d2mc))
               {
                  d2mc.gotoAndPlay(2);
               }
            }
         }
         for each(i in changeClothActObj)
         {
            i.goStart();
         }
      }
      
      public function stop() : void
      {
         var i:ChangeClothAction = null;
         var dmc:MovieClip = null;
         var d2mc:MovieClip = null;
         if(colorMC.numChildren == 0)
         {
            return;
         }
         var mc:MovieClip = colorMC.getChildAt(0) as MovieClip;
         if(Boolean(mc))
         {
            mc.gotoAndStop(1);
         }
         if(doodleMC.numChildren > 0)
         {
            dmc = doodleMC.getChildAt(0) as MovieClip;
            if(Boolean(dmc))
            {
               d2mc = dmc.getChildAt(0) as MovieClip;
               if(Boolean(d2mc))
               {
                  d2mc.gotoAndStop(1);
               }
            }
         }
         for each(i in changeClothActObj)
         {
            i.goOver();
         }
      }
      
      public function onEnterFrame() : void
      {
         var i:ChangeClothAction = null;
         var dmc:MovieClip = null;
         var d2mc:MovieClip = null;
         var mc:MovieClip = colorMC.getChildAt(0) as MovieClip;
         if(Boolean(mc))
         {
            if(mc.currentFrame == 1)
            {
               mc.gotoAndPlay(2);
            }
         }
         if(doodleMC.numChildren > 0)
         {
            dmc = doodleMC.getChildAt(0) as MovieClip;
            if(Boolean(dmc))
            {
               d2mc = dmc.getChildAt(0) as MovieClip;
               if(Boolean(d2mc))
               {
                  if(d2mc.currentFrame == 1)
                  {
                     d2mc.gotoAndPlay(2);
                  }
               }
            }
         }
         for each(i in changeClothActObj)
         {
            i.goEnterFrame();
         }
      }
      
      override public function changeCloth(clothArray:Array) : void
      {
         super.changeCloth(clothArray);
         colorMC.gotoAndStop(people.direction);
         this.defaultCloth.gotoAndStop(people.direction);
      }
      
      public function changeDirection(dir:String) : void
      {
         var i:ChangeClothAction = null;
         var mc:MovieClip = null;
         colorMC.gotoAndStop(dir);
         if(doodleMC.numChildren > 0)
         {
            mc = doodleMC.getChildAt(0) as MovieClip;
            if(Boolean(mc))
            {
               mc.gotoAndStop(dir);
            }
         }
         for each(i in changeClothActObj)
         {
            i.changeDir(dir);
         }
      }
      
      public function specialAction(peopleMode:BasePeoleModel, id:int) : void
      {
         var type:String = null;
         var changeAct:ChangeClothAction = null;
         var i:ChangeClothAction = null;
         var itemData:ClothData = ClothInfo.getItemInfo(id);
         var dir:int = itemData.actionDir;
         if(dir != -1)
         {
            type = itemData.type;
            people.direction = Direction.indexToStr(dir);
            changeAct = changeClothActObj[type];
            changeAct.specialAction(peopleMode,id,false);
         }
         else
         {
            colorMC.gotoAndStop(BasePeoleModel.SPECIAL_ACTION);
            for each(i in changeClothActObj)
            {
               i.specialAction(peopleMode,id);
            }
         }
      }
   }
}

