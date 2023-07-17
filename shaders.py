import moderngl as mgl
import numpy as np
import pygame as pg


class MyPyGame:
    def __init__(self):
        pg.init()
        self.sc = pg.display.set_mode((1200, 900), pg.DOUBLEBUF | pg.OPENGL)
        self.ctx = mgl.create_context()

        self.clock = pg.time.Clock()

        with open('programs/vertex.glsl') as f: self.vertex_shader = f.read()
        with open('programs/fragment.glsl') as f: self.fragment_shader = f.read()

        self.program = self.ctx.program(vertex_shader=self.vertex_shader,
                                            fragment_shader=self.fragment_shader)

        vertices_quad_2d = np.array([-1.0, 1.0, -1.0, -1.0, 1.0, -1.0,
                                     -1.0, 1.0, 1.0, -1.0, 1.0, 1.0], dtype=np.float32)
        vertex_buffer_quad_2d = self.ctx.buffer(vertices_quad_2d.tobytes())
        self.vertex_array = self.ctx.vertex_array(self.program, [(vertex_buffer_quad_2d, "2f", "in_position")])

    def run(self):
        t = 0
        while True:
            if self.clock.get_fps():
                t += 2/(self.clock.get_fps())
            pg.display.set_caption(f"{int(self.clock.get_fps())}")
            for event in pg.event.get():
                if event.type == pg.QUIT:
                    pg.quit()
                    quit()

            resolution = np.array([self.sc.get_width(), self.sc.get_height()], dtype=np.float32)
            self.program["resolution"].value = resolution
            self.program["t"].value = t

            self.vertex_array.render()

            pg.display.flip()
            self.clock.tick(1000)

if __name__ == '__main__':
    app = MyPyGame()
    app.run()