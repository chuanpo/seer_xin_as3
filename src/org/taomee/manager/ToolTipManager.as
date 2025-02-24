package org.taomee.manager
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import org.taomee.ds.HashMap;
   import org.taomee.utils.DisplayUtil;
   
   public class ToolTipManager
   {
      private static var _bitmap:Bitmap;
      
      private static var _cx:Number;
      
      private static var _cy:Number;
      
      private static var _listMap:HashMap;
      
      private static var _toolTip:Sprite;
      
      private static var _bg:DisplayObject;
      
      private static var _txt:TextField;
      
      private static var tf:TextFormat;
      
      private static var _bitmapdata:BitmapData;
      
      public function ToolTipManager()
      {
         super();
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
      
      private static function onMove(e:MouseEvent) : void
      {
         _toolTip.x = _cx + e.stageX;
         _toolTip.y = _cy + e.stageY;
      }
      
      private static function onOver(e:MouseEvent) : void
      {
         var obj:InteractiveObject = e.currentTarget as InteractiveObject;
         _txt.htmlText = _listMap.getValue(obj);
         _txt.setTextFormat(tf);
         if(Boolean(_bitmapdata))
         {
            _bitmapdata.dispose();
            _bitmapdata = null;
         }
         _bitmapdata = new BitmapData(_txt.textWidth + 2,_txt.textHeight);
         _bitmapdata.draw(_txt);
         _bitmap.bitmapData = _bitmapdata;
         _bitmap.x = 3;
         _bitmap.y = 3;
         _bg.width = _txt.textWidth + 10;
         _bg.height = _txt.textHeight + 10;
         PopUpManager.showForMouse(_toolTip,PopUpManager.TOP_RIGHT,5,-5);
         _cx = _toolTip.x - e.stageX;
         _cy = _toolTip.y - e.stageY;
         TaomeeManager.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
      }
      
      public static function add(obj:InteractiveObject, str:String) : void
      {
         obj.addEventListener(MouseEvent.ROLL_OVER,onOver);
         obj.addEventListener(MouseEvent.ROLL_OUT,onOut);
         _listMap.add(obj,str);
      }
      
      private static function onOut(e:MouseEvent) : void
      {
         onFinishTween();
      }
      
      private static function onFinishTween() : void
      {
         DisplayUtil.removeForParent(_toolTip);
         TaomeeManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
      }
      
      public static function setup(bg:DisplayObject) : void
      {
         _bg = bg;
         _listMap = new HashMap();
         _toolTip = new Sprite();
         _toolTip.mouseChildren = false;
         _toolTip.mouseEnabled = false;
         _toolTip.addChild(_bg);
         _txt = new TextField();
         _txt.width = 120;
         _txt.multiline = true;
         _txt.wordWrap = true;
         _txt.autoSize = TextFieldAutoSize.LEFT;
         _bitmap = new Bitmap();
         _toolTip.addChild(_bitmap);
         tf = new TextFormat();
      }
   }
}

