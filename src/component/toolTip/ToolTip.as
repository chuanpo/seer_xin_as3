package component.toolTip
{
   import flash.accessibility.AccessibilityProperties;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class ToolTip extends Sprite
   {
      private static var instance:ToolTip = null;
      
      private var label:TextField;
      
      private var area:DisplayObject;
      
      public function ToolTip()
      {
         super();
         label = new TextField();
         label.autoSize = TextFieldAutoSize.LEFT;
         label.selectable = false;
         label.multiline = false;
         label.wordWrap = false;
         label.defaultTextFormat = new TextFormat("宋体",12,6710886);
         label.text = "提示信息";
         label.x = 5;
         label.y = 2;
         addChild(label);
         redraw();
         visible = false;
         mouseChildren = false;
         mouseEnabled = false;
      }
      
      public static function init(base:DisplayObjectContainer) : void
      {
         if(instance == null)
         {
            instance = new ToolTip();
            base.addChild(instance);
         }
      }
      
      public static function register(area:DisplayObject, message:String) : void
      {
         var prop:AccessibilityProperties = null;
         if(instance != null)
         {
            prop = new AccessibilityProperties();
            prop.description = message;
            area.accessibilityProperties = prop;
            area.addEventListener(MouseEvent.MOUSE_OVER,instance.handler);
         }
      }
      
      public static function unregister(area:DisplayObject) : void
      {
         if(instance != null)
         {
            area.removeEventListener(MouseEvent.MOUSE_OVER,instance.handler);
         }
      }
      
      public function move(point:Point) : void
      {
         var lp:Point = this.parent.globalToLocal(point);
         this.x = lp.x - 6;
         this.y = lp.y - label.height - 12;
         if(!visible)
         {
            visible = true;
         }
      }
      
      public function hide() : void
      {
         this.area.removeEventListener(MouseEvent.MOUSE_OUT,this.handler);
         this.area.removeEventListener(MouseEvent.MOUSE_MOVE,this.handler);
         this.area = null;
         visible = false;
      }
      
      private function redraw() : void
      {
         var w:Number = 10 + label.width;
         var h:Number = 4 + label.height;
         this.graphics.clear();
         this.graphics.beginFill(0,0.4);
         this.graphics.drawRoundRect(3,3,w,h,5,5);
         this.graphics.moveTo(6,3 + h);
         this.graphics.lineTo(12,3 + h);
         this.graphics.lineTo(9,8 + h);
         this.graphics.lineTo(6,3 + h);
         this.graphics.endFill();
         this.graphics.beginFill(16777215);
         this.graphics.drawRoundRect(0,0,w,h,5,5);
         this.graphics.moveTo(3,h);
         this.graphics.lineTo(9,h);
         this.graphics.lineTo(6,5 + h);
         this.graphics.lineTo(3,h);
         this.graphics.endFill();
      }
      
      private function handler(event:MouseEvent) : void
      {
         switch(event.type)
         {
            case MouseEvent.MOUSE_OUT:
               this.hide();
               break;
            case MouseEvent.MOUSE_MOVE:
               this.move(new Point(event.stageX,event.stageY));
               break;
            case MouseEvent.MOUSE_OVER:
               this.show(event.target as DisplayObject);
               this.move(new Point(event.stageX,event.stageY));
         }
      }
      
      public function show(area:DisplayObject) : void
      {
         this.area = area;
         this.area.addEventListener(MouseEvent.MOUSE_OUT,this.handler);
         this.area.addEventListener(MouseEvent.MOUSE_MOVE,this.handler);
         label.text = area.accessibilityProperties.description;
         redraw();
      }
   }
}

