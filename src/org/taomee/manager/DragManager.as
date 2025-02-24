package org.taomee.manager
{
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import org.taomee.ds.HashMap;
   
   public class DragManager
   {
      private static var _collectionMap:HashMap = new HashMap();
      
      public function DragManager()
      {
         super();
      }
      
      public static function add(downTarget:InteractiveObject, moveTarget:Sprite) : void
      {
         if(downTarget is Sprite)
         {
            (downTarget as Sprite).buttonMode = true;
         }
         downTarget.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler);
         downTarget.addEventListener(MouseEvent.MOUSE_UP,onMouseUpHandler);
         _collectionMap.add(downTarget,moveTarget);
      }
      
      public static function remove(downTarget:InteractiveObject) : void
      {
         downTarget.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler);
         downTarget.removeEventListener(MouseEvent.MOUSE_UP,onMouseUpHandler);
         var sp:Sprite = _collectionMap.getValue(downTarget) as Sprite;
         if(Boolean(sp))
         {
            _collectionMap.remove(downTarget);
            sp = null;
         }
      }
      
      private static function onMouseUpHandler(e:MouseEvent) : void
      {
         var sp:Sprite = _collectionMap.getValue(e.currentTarget as InteractiveObject) as Sprite;
         if(Boolean(sp))
         {
            sp.stopDrag();
         }
      }
      
      private static function onMouseDownHandler(e:MouseEvent) : void
      {
         var sp:Sprite = _collectionMap.getValue(e.currentTarget as InteractiveObject) as Sprite;
         if(Boolean(sp))
         {
            DepthManager.bringToTop(sp);
            sp.startDrag();
         }
      }
   }
}

