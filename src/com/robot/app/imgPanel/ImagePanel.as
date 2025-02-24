package com.robot.app.imgPanel
{
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.UIManager;
   import com.robot.core.newloader.MCLoader;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.system.Security;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class ImagePanel
   {
      private static var panel:MovieClip;
      
      private static var mcloader:MCLoader;
      
      private static var url:String;
      
      private static var W:uint = 342;
      
      private static var H:uint = 231;
      
      public function ImagePanel()
      {
         super();
      }
      
      public static function setup(ip:String, port:uint) : void
      {
         Security.loadPolicyFile("http://" + ip + ":" + String(port) + "/crossdomain.xml");
      }
      
      public static function show(str:String) : void
      {
         url = str;
         if(!panel)
         {
            panel = UIManager.getMovieClip("ui_ImgPanel");
            panel["closeBtn"].addEventListener(MouseEvent.CLICK,closePanel);
            panel["saveBtn"].addEventListener(MouseEvent.CLICK,saveHandler);
            panel["imgMC"].mouseEnabled = false;
            panel["bgMC"].addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
            panel["bgMC"].addEventListener(MouseEvent.MOUSE_UP,upHandler);
            mcloader = new MCLoader("");
            mcloader.addEventListener(MCLoadEvent.SUCCESS,onSuccess);
            mcloader.addEventListener(MCLoadEvent.ERROR,onError);
         }
         panel["load_MC"].visible = true;
         DisplayUtil.align(panel,null,AlignType.MIDDLE_CENTER);
         LevelManager.appLevel.addChild(panel);
         try
         {
            mcloader.loader.close();
         }
         catch(e:Error)
         {
         }
         while(panel["imgMC"].numChildren > 0)
         {
            panel["imgMC"].removeChildAt(0);
         }
         panel["bgMC"].width = W;
         panel["bgMC"].height = H;
         resetPanel();
         mcloader.doLoad(str);
      }
      
      private static function downHandler(event:MouseEvent) : void
      {
         panel.startDrag();
      }
      
      private static function upHandler(event:MouseEvent) : void
      {
         panel.stopDrag();
      }
      
      private static function resetPanel() : void
      {
         panel["closeBtn"].x = panel["bgMC"].width - 42;
         panel["saveBtn"].x = (panel["bgMC"].width - panel["saveBtn"].width) / 2;
         panel["saveBtn"].y = panel["bgMC"].height - panel["saveBtn"].height - 10;
      }
      
      private static function closePanel(event:MouseEvent) : void
      {
         DisplayUtil.removeForParent(panel,false);
      }
      
      private static function onSuccess(event:MCLoadEvent) : void
      {
         var con:DisplayObject = event.getLoader();
         panel["load_MC"].visible = false;
         panel["imgMC"].addChild(con);
         panel["bgMC"].width = con.width + 46;
         panel["bgMC"].height = con.height + 32;
         if(panel["bgMC"].width < W)
         {
            panel["bgMC"].width = W;
         }
         if(panel["bgMC"].height < H)
         {
            panel["bgMC"].height = H;
         }
         resetPanel();
      }
      
      private static function saveHandler(event:MouseEvent) : void
      {
         SaveBmp.download(url);
      }
      
      private static function onError(event:MCLoadEvent) : void
      {
         DisplayUtil.removeForParent(panel,false);
         Alarm.show("该图片已经不存在！");
      }
   }
}

