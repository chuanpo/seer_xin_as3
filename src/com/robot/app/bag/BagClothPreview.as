package com.robot.app.bag
{
   import com.robot.core.config.xml.DoodleXMLInfo;
   import com.robot.core.info.clothInfo.PeopleItemInfo;
   import com.robot.core.info.item.ClothData;
   import com.robot.core.info.item.ClothInfo;
   import com.robot.core.mode.ISkeletonSprite;
   import com.robot.core.skeleton.ClothPreview;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.DisplayUtil;
   
   public class BagClothPreview extends ClothPreview
   {
      public function BagClothPreview(mc:Sprite, people:ISkeletonSprite = null, model:uint = 0)
      {
         super(mc,people,model);
      }
      
      override protected function initChangeCloth() : void
      {
         var i:String = null;
         var changeAct:BagChangeClothAction = null;
         for each(i in flagArray)
         {
            changeAct = new BagChangeClothAction(people,mcObj[i],i,model);
            changeClothActObj[i] = changeAct;
         }
      }
      
      public function showCloth(id:uint, level:uint) : void
      {
         var changeAct:BagChangeClothAction = null;
         var data:ClothData = ClothInfo.getItemInfo(id);
         changeAct = changeClothActObj[data.type];
         changeAct.changeClothByPath(id,data.getPrevUrl(level));
      }
      
      public function showCloths(cloths:Array) : void
      {
         var i:PeopleItemInfo = null;
         takeOffCloth();
         for each(i in cloths)
         {
            this.showCloth(i.id,i.level);
         }
      }
      
      public function getChangeClothAct(KEY:String) : BagChangeClothAction
      {
         return changeClothActObj[KEY];
      }
      
      public function showDoodle(texture:uint) : void
      {
         var url:String;
         DisplayUtil.removeAllChild(doodleMC);
         url = DoodleXMLInfo.getPrevURL(texture);
         if(url == "")
         {
            return;
         }
         ResourceManager.getResource(url,function(obj:DisplayObject):void
         {
            obj.x = 3;
            obj.y = 14;
            doodleMC.addChild(obj);
         });
      }
   }
}

