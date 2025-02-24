package org.taomee.component.tips
{
   import flash.display.InteractiveObject;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFormatAlign;
   import org.taomee.component.bgFill.SoildFillStyle;
   import org.taomee.component.containers.HBox;
   import org.taomee.component.control.MLabel;
   import org.taomee.component.layout.FlowLayout;
   import org.taomee.component.manager.MComponentManager;
   import org.taomee.component.manager.PopUpManager;
   import org.taomee.ds.HashMap;
   import org.taomee.utils.DisplayUtil;
   
   public class ToolTip
   {
      private static var box:HBox;
      
      private static var label:MLabel;
      
      private static var _cy:Number;
      
      private static var _cx:Number;
      
      private static var _listMap:HashMap;
      
      public function ToolTip()
      {
         super();
      }
      
      public static function add(obj:InteractiveObject, str:String) : void
      {
         obj.addEventListener(MouseEvent.ROLL_OVER,onOver);
         obj.addEventListener(MouseEvent.ROLL_OUT,onOut);
         _listMap.add(obj,str);
      }
      
      public static function remove(obj:InteractiveObject) : void
      {
         if(_listMap.containsKey(obj))
         {
            obj.removeEventListener(MouseEvent.ROLL_OVER,onOver);
            obj.removeEventListener(MouseEvent.ROLL_OUT,onOut);
            _listMap.remove(obj);
         }
         onFinishTween();
      }
      
      private static function onOut(e:MouseEvent) : void
      {
         onFinishTween();
      }
      
      private static function onMove(e:MouseEvent) : void
      {
         box.x = _cx + e.stageX;
         box.y = _cy + e.stageY;
      }
      
      private static function onOver(e:MouseEvent) : void
      {
         var obj:InteractiveObject = e.currentTarget as InteractiveObject;
         label.htmlText = " " + _listMap.getValue(obj);
         box.setSizeWH(label.width + 10,label.height + 4);
         box.append(label);
         box.cacheAsBitmap = true;
         MComponentManager.stage.addChild(box);
         PopUpManager.showForMouse(box,PopUpManager.BOTTOM_RIGHT,-12,20);
         _cx = box.x - e.stageX;
         _cy = box.y - e.stageY;
         MComponentManager.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
      }
      
      private static function onFinishTween() : void
      {
         DisplayUtil.removeForParent(box);
         MComponentManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
      }
      
      public static function setup() : void
      {
         _listMap = new HashMap();
         box = new HBox();
         box.filters = [new DropShadowFilter(3,45,0,0.6)];
         box.mouseChildren = false;
         box.mouseEnabled = false;
         box.valign = FlowLayout.MIDLLE;
         box.bgFillStyle = new SoildFillStyle(16116636,1,7,7);
         label = new MLabel();
         label.fontSize = 12;
         label.align = TextFormatAlign.CENTER;
         label.autoFitWidth = true;
      }
   }
}

