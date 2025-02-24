package org.taomee.manager
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Mouse;
   import org.taomee.utils.DisplayUtil;
   
   public class CursorManager
   {
      private static var _offset:Point;
      
      private static var _cursor:DisplayObject;
      
      private static var _root:DisplayObjectContainer = TaomeeManager.stage;
      
      public function CursorManager()
      {
         super();
         throw new Error("not constructor");
      }
      
      public static function destroy() : void
      {
         if(Boolean(_cursor))
         {
            removeCursor();
         }
      }
      
      public static function init(root:DisplayObjectContainer) : void
      {
         _root = root;
      }
      
      private static function onMouseMove(e:MouseEvent) : void
      {
         _cursor.x = _root.mouseX + _offset.x;
         _cursor.y = _root.mouseY + _offset.y;
         e.updateAfterEvent();
      }
      
      public static function setCursor(pCursor:DisplayObject, offset:Point = null, isHide:Boolean = true) : void
      {
         if(!_root)
         {
            throw new Error("not root");
         }
         if(Boolean(_cursor))
         {
            removeCursor();
         }
         if(isHide)
         {
            Mouse.hide();
         }
         _cursor = pCursor;
         if(_cursor is InteractiveObject)
         {
            InteractiveObject(_cursor).mouseEnabled = false;
            if(_cursor is DisplayObjectContainer)
            {
               DisplayObjectContainer(_cursor).mouseChildren = false;
            }
         }
         if(offset == null)
         {
            offset = new Point();
         }
         _offset = offset;
         _cursor.x = _root.mouseX + _offset.x;
         _cursor.y = _root.mouseY + _offset.y;
         _root.addChild(_cursor);
         _root.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
      }
      
      public static function removeCursor() : void
      {
         if(!_cursor)
         {
            return;
         }
         _root.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
         DisplayUtil.removeForParent(_cursor);
         _cursor = null;
         Mouse.show();
      }
      
      public static function bringToFront() : void
      {
         if(Boolean(_cursor))
         {
            _root.addChild(_cursor);
         }
      }
   }
}

