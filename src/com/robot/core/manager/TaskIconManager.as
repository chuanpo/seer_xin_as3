package com.robot.core.manager
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.Loader;
   import flash.filters.DropShadowFilter;
   import org.taomee.component.UIComponent;
   import org.taomee.component.containers.HBox;
   import org.taomee.component.control.UIMovieClip;
   import org.taomee.component.layout.FlowLayout;
   import org.taomee.ds.HashMap;
   import org.taomee.utils.Utils;
   
   public class TaskIconManager
   {
      private static var box:HBox;
      
      private static var _loader:Loader;
      
      private static var iconArray:HashMap = new HashMap();
      
      private static var filter:DropShadowFilter = new DropShadowFilter(5,45,0,0.6);
      
      public function TaskIconManager()
      {
         super();
      }
      
      public static function setup(loader:Loader) : void
      {
         _loader = loader;
         box = new HBox();
         box.width = MainManager.getStageWidth() - 15;
         box.height = 94;
         box.gap = 10;
         box.halign = FlowLayout.RIGHT;
         box.valign = FlowLayout.MIDLLE;
         LevelManager.iconLevel.addChild(box);
      }
      
      public static function getIcon(str:String) : InteractiveObject
      {
         return Utils.getDisplayObjectFromLoader(str,_loader) as InteractiveObject;
      }
      
      public static function addIcon(icon:DisplayObject) : void
      {
         var comp:UIComponent = null;
         if(!iconArray.containsKey(icon))
         {
            comp = new UIMovieClip(icon);
            box.appendAt(comp,0);
            icon.filters = [filter];
            iconArray.add(icon,comp);
         }
      }
      
      public static function delIcon(icon:DisplayObject) : void
      {
         var comp:UIComponent = null;
         if(iconArray.containsKey(icon))
         {
            comp = iconArray.getValue(icon) as UIComponent;
            box.remove(comp);
            iconArray.remove(icon);
         }
      }
   }
}

