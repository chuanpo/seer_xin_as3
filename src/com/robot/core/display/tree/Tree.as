package com.robot.core.display.tree
{
   import com.robot.core.utils.ArrayUtils;
   import flash.xml.XMLDocument;
   import flash.xml.XMLNode;
   
   public class Tree
   {
      private var _root:INode;
      
      public function Tree(root:INode)
      {
         super();
         this._root = root;
      }
      
      public static function visit(node:INode, fnc:Function) : void
      {
         var n:INode = null;
         for each(n in node.children)
         {
            fnc(n);
            visit(n,fnc);
         }
      }
      
      public static function clone(node:INode) : INode
      {
         var r:INode = new Node(node.name,null,node.data);
         cloneHelper(node,r);
         return r;
      }
      
      private static function cloneHelper(node:INode, newNode:INode) : void
      {
         var n:INode = null;
         for each(n in node.children)
         {
            cloneHelper(n,newNode.addChild(new Node(n.name,newNode,n.data)));
         }
      }
      
      public static function toXml(tree:Tree, rootNodeName:String = "tree", nodeName:String = "node") : XML
      {
         var x:XMLDocument = new XMLDocument();
         var xmlNode:XMLNode = x.createElement(rootNodeName);
         x.appendChild(xmlNode);
         getXml(tree.root,xmlNode,x,nodeName);
         return new XML(x.toString());
      }
      
      private static function getXml(node:INode, xml:XMLNode, x:XMLDocument, nodeName:String) : void
      {
         var n:INode = null;
         var e:XMLNode = null;
         for each(n in node.children)
         {
            if(nodeName == null)
            {
               nodeName = n.name;
            }
            e = x.createElement(nodeName);
            if(nodeName != n.name)
            {
               e.attributes = {"name":n.name};
            }
            else
            {
               nodeName = null;
            }
            xml.appendChild(e);
            getXml(n,e,x,nodeName);
         }
      }
      
      public static function fromXml(tree:Tree, xml:XML, clazz:Class = null) : Tree
      {
         if(clazz == null)
         {
            clazz = Node;
         }
         var x:XMLDocument = new XMLDocument();
         x.parseXML(xml);
         createTree(x.firstChild,tree.root = new clazz("tree",null),clazz);
         return tree;
      }
      
      private static function createTree(xmlNode:XMLNode, node:INode, clazz:Class) : void
      {
         var c:XMLNode = null;
         var n:INode = null;
         for each(c in xmlNode.childNodes)
         {
            if(c.nodeName != null)
            {
               n = new clazz(c.attributes["name"],node);
               node.addChild(n);
               createTree(c,n,clazz);
            }
         }
      }
      
      public static function getParentNodeChain(node:INode) : Array
      {
         var chain:Array = new Array();
         getParentNodeChainHelper(node,chain);
         return chain;
      }
      
      private static function getParentNodeChainHelper(node:INode, chain:Array) : void
      {
         var parent:INode = node.parent as INode;
         if(Boolean(parent))
         {
            chain.push(parent);
            getParentNodeChainHelper(parent,chain);
         }
      }
      
      public static function getCommonParent(node1:INode, node2:INode) : INode
      {
         var n1:INode = null;
         var n2:INode = null;
         var chain1:Array = getParentNodeChain(node1);
         var chain2:Array = getParentNodeChain(node2);
         for each(n1 in chain1)
         {
            for each(n2 in chain2)
            {
               if(n1 == n2)
               {
                  return n1;
               }
            }
         }
         return null;
      }
      
      public static function getNodesUntilCommonParent(node:INode, chain:Array) : Array
      {
         var nodes:Array = new Array();
         getNodesUntilCommonParentHelper(node,nodes,chain);
         return nodes;
      }
      
      private static function getNodesUntilCommonParentHelper(node:INode, nodes:Array, chain:Array) : void
      {
         nodes.push(node);
         var parent:INode = node.parent as INode;
         if(Boolean(parent) && (!ArrayUtils.contains(chain,parent) && !ArrayUtils.contains(chain,node)))
         {
            getNodesUntilCommonParentHelper(parent,nodes,chain);
         }
      }
      
      public static function getNodeByNameID(name:String, node:INode) : INode
      {
         var n:INode = null;
         var r:INode = null;
         if(node.name == name)
         {
            return node;
         }
         for each(n in node.children)
         {
            r = getNodeByNameID(name,n);
            if(r != null)
            {
               return r;
            }
         }
         return null;
      }
      
      public static function getAllChildren(node:INode) : Array
      {
         var childs:Array = new Array();
         getAllChildrenHelper(node,childs);
         return childs;
      }
      
      private static function getAllChildrenHelper(node:INode, childs:Array) : void
      {
         var n:INode = null;
         for each(n in node.children)
         {
            childs.push(n);
            getAllChildrenHelper(n,childs);
         }
      }
      
      public function get root() : INode
      {
         return this._root;
      }
      
      public function set root(root:INode) : void
      {
         this._root = root;
      }
      
      public function toArray() : Array
      {
         var ar:Array = new Array();
         this.walk(this._root,ar);
         return ar;
      }
      
      private function walk(node:INode, ar:Array) : void
      {
         var n:INode = null;
         ar.push(node);
         for each(n in node.children)
         {
            this.walk(n,ar);
         }
      }
      
      public function finalize() : void
      {
         this._root.finalize();
      }
   }
}

