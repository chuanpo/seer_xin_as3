package com.robot.core.npc
{
   import com.robot.core.config.xml.EmotionXMLInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.TaskIconManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.component.containers.Box;
   import org.taomee.component.containers.VBox;
   import org.taomee.component.control.MLabel;
   import org.taomee.component.control.MLabelButton;
   import org.taomee.component.control.MLoadPane;
   import org.taomee.component.layout.FlowLayout;
   import org.taomee.component.layout.FlowWarpLayout;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class NpcDialog
   {
      private static var _npcMc:Sprite;
      
      private static var _dialogA:Array;
      
      private static var _questionA:Array;
      
      private static var _handlerA:Array;
      
      private static var _bgMc:Sprite;
      
      private static var _prevBtn:MovieClip;
      
      private static var _nextBtn:MovieClip;
      
      private static var _curNpcPath:String;
      
      private static var txtBox:Box;
      
      private static var btnBox:VBox;
      
      private static var mcL:MLoadPane;
      
      private static const MAX:uint = 3;
      
      private static var _curIndex:uint = 0;
      
      private static var _btnA:Array = [];
      
      setup();
      
      public function NpcDialog()
      {
         super();
      }
      
      public static function setup() : void
      {
         _bgMc = TaskIconManager.getIcon("NPC_BG_MC") as Sprite;
         _nextBtn = _bgMc["nextBtn"];
         _prevBtn = _bgMc["prevBtn"];
         _prevBtn.gotoAndStop(1);
         _prevBtn.visible = false;
         txtBox = new Box();
         txtBox.x = 144;
         txtBox.y = 20;
         txtBox.setSizeWH(520,112);
         txtBox.layout = new FlowWarpLayout(FlowWarpLayout.LEFT,FlowWarpLayout.BOTTOM,-3,-2);
         btnBox = new VBox(2);
         btnBox.x = 144;
         btnBox.y = 32;
         btnBox.setSizeWH(520,112);
         btnBox.valign = FlowLayout.BOTTOM;
         _bgMc.addChild(btnBox);
         _bgMc.addChild(txtBox);
         _bgMc.addChild(_nextBtn);
         _bgMc.addChild(_prevBtn);
      }
      
      public static function show(npcId:uint, dialogA:Array, questionA:Array = null, handlerA:Array = null) : void
      {
         var i1:int = 0;
         LevelManager.closeMouseEvent();
         if(_curNpcPath != "")
         {
            ResourceManager.cancelURL(_curNpcPath);
         }
         if(Boolean(_npcMc))
         {
            DisplayUtil.removeForParent(_npcMc);
            _npcMc = null;
         }
         if(_btnA.length > 0)
         {
            for(i1 = 0; i1 < _btnA.length; i1++)
            {
               (_btnA[i1] as MLabelButton).removeEventListener(MouseEvent.CLICK,onTxtBtnClickHandler);
               _btnA[i1] = null;
            }
         }
         _btnA = new Array();
         txtBox.removeAll();
         btnBox.removeAll();
         _curNpcPath = NPC.getDialogNpcPathById(npcId);
         _curIndex = 0;
         _dialogA = dialogA;
         _questionA = questionA;
         _handlerA = handlerA;
         _prevBtn.visible = false;
         _prevBtn.gotoAndStop(1);
         if(_dialogA.length <= 1)
         {
            _nextBtn.visible = false;
            _nextBtn.gotoAndStop(1);
         }
         else
         {
            _nextBtn.visible = true;
            _nextBtn.play();
         }
         addTxtBtn();
         shwoTxt(_curIndex);
         addEvent();
         LevelManager.appLevel.addChild(_bgMc);
         DisplayUtil.align(_bgMc,null,AlignType.BOTTOM_CENTER,new Point(0,-60));
         ResourceManager.getResource(_curNpcPath,onComHandler);
      }
      
      private static function addTxtBtn() : void
      {
         var i1:int = 0;
         var labelBtn:MLabelButton = null;
         if(_questionA != null)
         {
            for(i1 = 0; i1 < _questionA.length; i1++)
            {
               labelBtn = new MLabelButton(_questionA[i1]);
               labelBtn.overColor = 65535;
               labelBtn.outColor = 16776960;
               labelBtn.underLine = true;
               labelBtn.buttonMode = true;
               btnBox.append(labelBtn);
               labelBtn.name = "btn" + i1;
               labelBtn.addEventListener(MouseEvent.CLICK,onTxtBtnClickHandler);
               _btnA.push(labelBtn);
            }
         }
      }
      
      private static function onTxtBtnClickHandler(e:MouseEvent) : void
      {
         hide();
         LevelManager.openMouseEvent();
         var nameStr:String = (e.currentTarget as MLabelButton).name;
         var index:uint = uint(nameStr.slice(3,nameStr.length));
         if(Boolean(_handlerA))
         {
            if(_handlerA[index] != null && _handlerA[index] != undefined)
            {
               (_handlerA[index] as Function)();
            }
         }
      }
      
      private static function onComHandler(mc:DisplayObject) : void
      {
         if(Boolean(mcL))
         {
            DisplayUtil.removeForParent(mcL);
            mcL.destroy();
            mcL = null;
         }
         _npcMc = mc as Sprite;
         DisplayUtil.stopAllMovieClip(_npcMc as MovieClip);
         mcL = new MLoadPane(_npcMc);
         if(_npcMc.width > _npcMc.height)
         {
            mcL.fitType = MLoadPane.FIT_WIDTH;
         }
         else
         {
            mcL.fitType = MLoadPane.FIT_HEIGHT;
         }
         mcL.setSizeWH(160,170);
         mcL.x = -15;
         mcL.y = -18;
         _bgMc.addChild(mcL);
      }
      
      private static function addEvent() : void
      {
         _nextBtn.addEventListener(MouseEvent.CLICK,onNextClickHandler);
         _prevBtn.addEventListener(MouseEvent.CLICK,onPrevClickHandler);
      }
      
      private static function removeEvent() : void
      {
         _nextBtn.removeEventListener(MouseEvent.CLICK,onNextClickHandler);
         _prevBtn.removeEventListener(MouseEvent.CLICK,onPrevClickHandler);
      }
      
      private static function onNextClickHandler(e:MouseEvent) : void
      {
         ++_curIndex;
         if(_curIndex >= _dialogA.length)
         {
            _nextBtn.visible = false;
            _nextBtn.stop();
            _prevBtn.visible = true;
            _prevBtn.play();
         }
         else
         {
            shwoTxt(_curIndex);
            if(_curIndex == _dialogA.length - 1)
            {
               _nextBtn.visible = false;
               _nextBtn.stop();
               _prevBtn.visible = true;
               _prevBtn.play();
            }
         }
      }
      
      private static function onPrevClickHandler(e:MouseEvent) : void
      {
         --_curIndex;
         if(_curIndex < 0)
         {
            _nextBtn.visible = true;
            _nextBtn.play();
            _prevBtn.visible = false;
            _prevBtn.stop();
         }
         else
         {
            shwoTxt(_curIndex);
            if(_curIndex == 0)
            {
               _nextBtn.visible = true;
               _nextBtn.play();
               _prevBtn.visible = false;
               _prevBtn.stop();
            }
         }
      }
      
      private static function hide() : void
      {
         DisplayUtil.removeForParent(_bgMc);
         txtBox.removeAll();
         btnBox.removeAll();
      }
      
      private static function shwoTxt(index:uint) : void
      {
         var i:String = null;
         var j:uint = 0;
         var s:String = null;
         var lable:MLabel = null;
         var loadPanel:MLoadPane = null;
         txtBox.removeAll();
         var str:String = "    " + _dialogA[index];
         var parse:ParseDialogStr = new ParseDialogStr(str);
         var count:uint = 0;
         for each(i in parse.strArray)
         {
            for(j = 0; j < i.length; j++)
            {
               s = i.charAt(j);
               lable = new MLabel(s);
               lable.textColor = uint("0x" + parse.getColor(count));
               lable.cacheAsBitmap = true;
               txtBox.append(lable);
            }
            count++;
            if(parse.getEmotionNum(count) != -1)
            {
               loadPanel = new MLoadPane(EmotionXMLInfo.getURL("#" + parse.getEmotionNum(count)),MLoadPane.FIT_NONE,MLoadPane.MIDDLE,MLoadPane.MIDDLE);
               loadPanel.setSizeWH(45,40);
               txtBox.append(loadPanel);
            }
         }
      }
   }
}

