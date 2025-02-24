package org.taomee.component.layout
{
   import org.taomee.component.UIComponent;
   
   public class FitSizeLayout extends EmptyLayout implements ILayoutManager
   {
      private static const TYPE:String = "fitSizeLayout";
      
      public function FitSizeLayout()
      {
         super();
      }
      
      override public function getType() : String
      {
         return TYPE;
      }
      
      override public function doLayout() : void
      {
         var i:UIComponent = null;
         for each(i in container.compList)
         {
            i.y = 0;
            i.x = 0;
            i.setSizeWH(container.width,container.height);
         }
      }
   }
}

