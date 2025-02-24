package com.robot.core.manager.book
{
   import com.robot.core.config.ClientConfig;
   import com.robot.core.mode.AppModel;
   
   public class BookManager
   {
      private static var _panel:AppModel;
      
      private static var _curBookId:String;
      
      public function BookManager()
      {
         super();
      }
      
      private static function showNow(str:String) : void
      {
         _panel = new AppModel(ClientConfig.getBookModule(str),"正在打开手册");
         _panel.setup();
         _panel.show();
         _curBookId = str;
      }
      
      public static function hide() : void
      {
         if(Boolean(_panel))
         {
            _panel.hide();
         }
      }
      
      public static function destroy() : void
      {
         if(Boolean(_panel))
         {
            _panel.hide();
            _panel.destroy();
         }
      }
      
      public static function show(bookId:String) : void
      {
         if(_panel == null)
         {
            showNow(bookId);
         }
         else if(_curBookId == bookId)
         {
            _panel.show();
         }
         else
         {
            _panel.destroy();
            _panel = null;
            showNow(bookId);
         }
      }
   }
}

