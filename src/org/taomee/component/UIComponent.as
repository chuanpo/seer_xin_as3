package org.taomee.component
{
   import org.taomee.component.bgFill.IBgFillStyle;
   import org.taomee.component.event.MComponentEvent;
   import org.taomee.component.manager.IToolTipManager;
   import org.taomee.component.tips.ToolTip;
   
   [Event(name="onUpdate",type="org.taomee.component.event.MComponentEvent")]
   public class UIComponent extends MSprite implements IToolTipManager
   {
      private var _bgFillStyle:IBgFillStyle;
      
      public function UIComponent()
      {
         super();
      }
      
      override public function destroy() : void
      {
         if(Boolean(_bgFillStyle))
         {
            _bgFillStyle.clear();
         }
         _bgFillStyle = null;
         super.destroy();
      }
      
      public function set enabled(b:Boolean) : void
      {
         this.mouseChildren = b;
         this.mouseEnabled = b;
         if(b)
         {
            this.alpha = 1;
         }
         else
         {
            this.alpha = 0.5;
         }
      }
      
      override protected function revalidate() : void
      {
         super.revalidate();
         if(Boolean(_bgFillStyle))
         {
            _bgFillStyle.reDraw();
         }
         dispatchEvent(new MComponentEvent(MComponentEvent.UPDATE));
      }
      
      public function setSizeWH(w:int, h:int) : void
      {
         if(w == width && h == height)
         {
            return;
         }
         width = w;
         height = h;
      }
      
      public function set toolTip(str:String) : void
      {
         ToolTip.add(this,str);
      }
      
      public function clearTip() : void
      {
         ToolTip.remove(this);
      }
      
      public function set bgFillStyle(bs:IBgFillStyle) : void
      {
         if(bs == null)
         {
            if(Boolean(_bgFillStyle))
            {
               _bgFillStyle.clear();
            }
            _bgFillStyle = null;
         }
         else
         {
            if(Boolean(_bgFillStyle))
            {
               _bgFillStyle.clear();
            }
            _bgFillStyle = bs;
            _bgFillStyle.draw(bgMC);
         }
      }
   }
}

