package com.robot.app.bag
{
   import com.robot.core.info.clothInfo.PeopleItemInfo;
   import com.robot.core.info.item.ClothInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.mode.ISkeletonSprite;
   import com.robot.core.skeleton.ChangeClothAction;
   import com.robot.core.skeleton.ClothPreview;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.events.DynamicEvent;
   
   public class BagChangeClothAction extends ChangeClothAction
   {
      public static const TAKE_OFF_CLOTH:String = "takeOffCloth";
      
      public static const REPLACE_CLOTH:String = "replaceCloth";
      
      public static const USE_CLOTH:String = "useCloth";
      
      public static const CLOTH_CHANGE:String = "bagClothChange";
      
      public function BagChangeClothAction(people:ISkeletonSprite, container:Sprite, type:String, model:uint)
      {
         super(people,container,type,model);
      }
      
      override protected function unloadCloth(event:MouseEvent) : void
      {
         var id:uint = 0;
         if(clothID == ClothInfo.DEFAULT_FOOT || clothID == ClothInfo.DEFAULT_HEAD || clothID == ClothInfo.DEFAULT_WAIST)
         {
            return;
         }
         if(Boolean(clothSWF))
         {
            clothSWF.parent.removeChild(clothSWF);
            clothSWF = null;
            MainManager.actorModel.dispatchEvent(new DynamicEvent(BagChangeClothAction.TAKE_OFF_CLOTH,clothID));
            clothID = 0;
            MainManager.actorModel.dispatchEvent(new Event(BagChangeClothAction.CLOTH_CHANGE));
         }
         if(type == ClothPreview.FLAG_HEAD)
         {
            id = uint(ClothInfo.DEFAULT_HEAD);
         }
         else if(type == ClothPreview.FLAG_FOOT)
         {
            id = uint(ClothInfo.DEFAULT_FOOT);
         }
         else
         {
            if(type != ClothPreview.FLAG_WAIST)
            {
               return;
            }
            id = uint(ClothInfo.DEFAULT_WAIST);
         }
         var url:String = ClothInfo.getItemInfo(id).getPrevUrl();
         this.changeClothByPath(id,url);
      }
      
      override public function changeCloth(clothInfo:PeopleItemInfo) : void
      {
         if(this.clothID != 0 && this.clothID != ClothInfo.DEFAULT_FOOT && this.clothID != ClothInfo.DEFAULT_HEAD && this.clothID != ClothInfo.DEFAULT_WAIST)
         {
            if(Boolean(MainManager.actorModel))
            {
               MainManager.actorModel.dispatchEvent(new DynamicEvent(REPLACE_CLOTH,this.clothID));
            }
         }
         else if(Boolean(MainManager.actorModel))
         {
            MainManager.actorModel.dispatchEvent(new DynamicEvent(USE_CLOTH,this.clothID));
         }
         this.clothID = clothInfo.id;
         beginLoad();
         if(Boolean(MainManager.actorModel))
         {
            MainManager.actorModel.dispatchEvent(new Event(BagChangeClothAction.CLOTH_CHANGE));
         }
      }
      
      override public function changeClothByPath(clothID:int, path:String) : void
      {
         if(!(clothID == ClothInfo.DEFAULT_FOOT || clothID == ClothInfo.DEFAULT_HEAD || clothID == ClothInfo.DEFAULT_WAIST))
         {
            if(this.clothID != 0 && this.clothID != ClothInfo.DEFAULT_FOOT && this.clothID != ClothInfo.DEFAULT_HEAD && this.clothID != ClothInfo.DEFAULT_WAIST)
            {
               if(Boolean(MainManager.actorModel))
               {
                  MainManager.actorModel.dispatchEvent(new DynamicEvent(REPLACE_CLOTH,this.clothID));
               }
            }
            else if(Boolean(MainManager.actorModel))
            {
               MainManager.actorModel.dispatchEvent(new DynamicEvent(USE_CLOTH,this.clothID));
            }
         }
         this.clothID = clothID;
         beginLoad(path);
         if(Boolean(MainManager.actorModel))
         {
            MainManager.actorModel.dispatchEvent(new Event(BagChangeClothAction.CLOTH_CHANGE));
         }
      }
   }
}

