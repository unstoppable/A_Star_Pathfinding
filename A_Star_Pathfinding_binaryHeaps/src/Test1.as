package
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.TriangleCulling;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D;

	[SWF(width=800, height=450, backgroundColor=0xE8F0F8, frameRate=25)]
	public class Test1 extends Sprite
	{
		public function Test1()
		{
			stage.align=StageAlign.TOP;
			stage.scaleMode=StageScaleMode.NO_BORDER;


			var n:int=32;
			var m:int=32;
			var vertices:Vector.<Number>=new Vector.<Number>();
			var indices:Vector.<int>=new Vector.<int>()
			var uvtData:Vector.<Number>=new Vector.<Number>()
			var projectedVerts:Vector.<Number>=new Vector.<Number>(n * m * 4)
			var perlinTerrain:BitmapData=new BitmapData(n, m, false);
			var heightGradient:BitmapData=new BitmapData(288, 2, false, 0xE8F0F8)
			var newBitmap:BitmapData=heightGradient.clone()
			var perlinPoint:Point=new Point()
			var i:int
			var j:int
			var ii:int=0
			var ij:int
			var ix:Number
			var iy:Number
			var tmp:Number
			var phase:Number=0.0
			var projectionMatrix:Matrix3D
			var rotAngle:Number=0.25 * Math.PI;

			heightGradient.setVector(new Rectangle(0, 0, heightGradient.width, 1), Vector.<uint>([0xebe9da, 0xebe1db, 0xe9e9da, 0xebe3cf, 0xe9ebce, 0xebe9cd, 0xe9e9cd, 0xe3e1cb, 0xebe3ca, 0xe3e9c9, 0xe1e9cb, 0xe1e9cf, 0xe3e3cf, 0xe1e3c5, 0xe9ebc5, 0xebe3c3, 0xe1ebc3, 0xebe3ca, 0xe1dfcb, 0xebdfca, 0xe1ddbf, 0xe1ddbf, 0xe1dbbf, 0xe3dbbe, 0xe3dbbb, 0xebdaba, 0xe3dfb9, 0xebdfba, 0xe9d5b7, 0xebddbe, 0xe1dbbf, 0xe1dbb7, 0xebd3bf, 0xe3dab6, 0xe3dab4, 0xebdbbd, 0xe1d3bf, 0xe9d3b4, 0xe9dbb6, 0xebdbb5, 0xe9d2b6, 0xe9dbbd, 0xe3dbb5, 0xebdabe, 0xebd2b6, 0xe9dab6, 0xe1d3bd, 0xebd2b5, 0xe3d2bc, 0xdbcaaf, 0xd5caa7, 0xcfbb9e, 0xcbb39c, 0xc3aa8e, 0xbda28d, 0xbf9a7c, 0xb39a74, 0xab8b6d, 0xa5826c, 0x9f7b5d, 0x997255, 0x9b6b4d, 0x8d624e, 0x875a3c, 0x875a3c, 0x885b3f, 0x8b5d3e, 0x8a5f3f, 0x8b5e48, 0x8c5f41, 0x8d604a, 0x8e6143, 0x8f6a4f, 0x92634f, 0x91644f, 0x926547, 0x936f48, 0x9e6f49, 0x9f684a, 0x96694b, 0x966b4b, 0x936f49, 0x8c6f4f, 0x876b47, 0x82634b, 0x7d5f4b, 0x7a5f3f, 0x735b3d, 0x6e5b3b, 0x6b5f3b, 0x6c5f37, 0x5f5335, 0x5a5933, 0x574f33, 0x5a4d2f, 0x4b4b2d, 0x4b4b2d, 0x4b4b2d, 0x4f472f, 0x474d2f, 0x43432d, 0x41492f, 0x3f3f2d, 0x3d3d2d, 0x3b3b2d, 0x393b2f, 0x37372d, 0x3f372d, 0x33332d, 0x3b332d, 0x2f2f2f, 0x2f2d2f, 0x2d2d2f, 0x2c302c, 0x2b332b, 0x2a3e2a, 0x2b3b2b, 0x2a3e29, 0x2f3f2f, 0x264a27, 0x274f25, 0x24482f, 0x2b4b23, 0x224f2a, 0x215121, 0x2a5622, 0x1f5f1f, 0x1e5a1f, 0x1e5b1f, 0x225b23, 0x265f2c, 0x2a5d27, 0x2e5e2b, 0x3a5f2f, 0x3e683b, 0x3a6933, 0x3e6a3e, 0x42633b, 0x4e643f, 0x4a6f3f, 0x4e674a, 0x5a6745, 0x5e6848, 0x5a6b4b, 0x5a694b, 0x5a6f57, 0x5a7f5f, 0x5a7b62, 0x5a8162, 0x5a8768, 0x5a8f70, 0x5a9374, 0x729970, 0x6F9f62, 0x72ad60, 0x7aab6f, 0x95Ab80, 0x6ed5de, 0x5acbdb, 0x5abdcb, 0x5ac3db, 0x5ebbcf, 0x5abbcf, 0x4eabc9, 0x4aabcf, 0x5eabd3, 0x4a93c0, 0x3e8bbd, 0x3a8bba, 0x3e7bb7, 0x3273b6, 0x2e6bb1, 0x2a6bae, 0x3e6bbb, 0x2a5baa, 0x1e4ba7, 0x1e4baf, 0x1e4baa, 0x1e4b9f, 0x1e4a9e, 0x1e4799, 0x1e4696, 0x1e4f9b, 0x1e4f90, 0x1e4b8d, 0x1e4a8b, 0x1e498f, 0x1e4887, 0x1e3f89, 0x1e3f7f, 0x1e3f7b, 0x1e3f7a, 0x1e3e79, 0x1f3f78, 0x203e7a, 0x2b3c7a, 0x223c79, 0x2b3d79, 0x2e3f79, 0x2d3d79, 0x263c7a, 0x273d79, 0x283e78, 0x293e78, 0x2a3d78, 0x2b3c7a, 0x2c3d7b, 0x2d3d78, 0x2f3f78, 0x2e3d7b, 0x2b3e7b, 0x2a3f79, 0x294978, 0x2a4b7a, 0x27427a, 0x264b79, 0x2d447a, 0x2c4d7b, 0x2b4f7a, 0x2a4778, 0x294879, 0x204979, 0x1f4b79, 0x1e4b7b, 0x1e4b79, 0x1e4d79, 0x1e4d7a, 0x1e4f7b, 0x1e4f7d, 0x1e587d, 0x1e537f, 0x1e537f, 0x1e5b81, 0x1e5489, 0x1e5d8b, 0x1e5f83, 0x1e5f85, 0x1e5985, 0x1e5b8f, 0x1e5b87, 0x1e5a8f, 0x1e5a86, 0x1e5e85, 0x1e5f8d, 0x1e5283, 0x1e5b8a, 0x1e4e8b, 0x1e4d8a, 0x1e4b7f, 0x1e4a7e, 0x1e477f, 0x1e457f, 0x1e437b, 0x1e407a, 0x1e3e79, 0x1e3d7a, 0x1e3c78, 0x2b477f, 0x3a5b8f, 0x455d8f, 0x5a6a96, 0x5f7b9b, 0x6e7eaa, 0x798ba9, 0x8694b1, 0x939fb7, 0xaaabbe, 0xadbfc7, 0xbac2cd, 0xcfcbd3, 0xdcd6db, 0xebebeb, 0xe9e3e1, 0xe0e3e8, 0xdfdfdf, 0xdedfde, 0xdddfdd, 0xdcdddf, 0xdbdbdb, 0xdadbda, 0xd9dbd9, 0xd8d9d8, 0xdfd7d7, 0xdedede, 0xd7dddd, 0xd4d6dd, 0xd3d3db, 0xdad2d2]));

			x=stage.stageWidth / 2.0;

			y=stage.stageHeight / 2.0;

			for (i=0; i != n; i++)
			{
				for (j=0; j != m; j++)
				{

					vertices.push((ix=1.0001 - i / (n - 1)) + (iy=j / (m - 1) - 1.0), 0.0, ix - iy, iy + ix, -0.2, ix - iy);

					uvtData.push(j / m, 0.9 * (tmp=Math.max(1.0 - j / m, 1.0 - i / n)), 1.0, 0.99, tmp, 1.0);

				}
			}

			for (i=0; i != n - 1; i++)
			{

				for (j=0; j != m - 1; j++)
				{
					indices.push(ii, ii + m + m + 2, ii + 2, ii + m + m, ii + m + m + 2, ii, ++ii, ii + 2, ii + m + m + 2, ii + m + m, ii, (ii++) + m + m + 2);
				}

				ii+=2;

			}

			addEventListener(Event.ENTER_FRAME, function update(e:Event=null, ii:int=0):void
			{
				;

				perlinTerrain.perlinNoise(n, m, 5, 11, false, true, 4, false, [perlinPoint=new Point(perlinPoint.x-=0.5 * Math.sin(rotAngle=(15.0 * rotAngle + Math.max(-0.5, Math.min((tmp=0.5 * Math.PI * ((i=perlinTerrain.getPixel(n - 3, m - 1) + perlinTerrain.getPixel(n - 2, m - 1)) - 0x70) / (i - (perlinTerrain.getPixel(n - 1, m - 3) + perlinTerrain.getPixel(n - 1, m - 2)) + 0.01)), 2.0))) / 16.0), perlinPoint.y-=0.5 * Math.cos(rotAngle)), perlinPoint, perlinPoint, perlinPoint, perlinPoint]);

				ij=((ij=perlinTerrain.getPixel(n - 1, m - 1)) > 128) ? 128 - 20 : ij - 20;

				tmp=1.0 / (1.2 + Math.sin(0.333 * (phase+=0.02)));

				for (i=0; i != n; i++)
				{
					for (j=0; j != m; j++)
					{
						vertices[ii + 1]=Math.min(0.1, Math.pow((uvtData[ii]=perlinTerrain.getPixel(i, j) / 0xFF), tmp) - Math.pow(ij / 0xFF, tmp));

						uvtData[ii + 3]=1.0 - (0.15 + 0.05 * Math.cos(phase)) * uvtData[(ii+=6) - 6];

					}
				}

				projectionMatrix=new PerspectiveProjection().toMatrix3D();
				projectionMatrix.appendRotation(-12.0 * (rotAngle - Math.PI / 4) / Math.PI, Vector3D.Z_AXIS);

				Utils3D.projectVectors(projectionMatrix, vertices, projectedVerts, uvtData);

				newBitmap.applyFilter(heightGradient, heightGradient.rect, new Point(), new ColorMatrixFilter([1.0, tmp=0.2 + 0.25 * Math.cos(phase), tmp, 0, -tmp * (0xF0 + 0xF8), tmp*=1.0, 1.0, tmp, 0, -tmp * (0xE8 + 0xF8), tmp*=0.7, tmp, 1.0, 0, -tmp * (0xE8 + 0xF0), 0.0, 0.0, 0.0, 1.0, 0.0]));

				graphics.clear();

				graphics.beginBitmapFill(newBitmap, null, false, true);

				graphics.drawTriangles(projectedVerts, indices, uvtData, TriangleCulling.POSITIVE);

			});
		}


	}
}
