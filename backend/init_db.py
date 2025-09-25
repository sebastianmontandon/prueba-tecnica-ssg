from sqlalchemy import text
from database import engine
from models import Base

def init_database():
    # Crear todas las tablas
    Base.metadata.create_all(bind=engine)

    with engine.connect() as connection:
        # Tipos de usuario básicos
        connection.execute(text("""
            INSERT OR IGNORE INTO users_tipos (id, nombre, descripcion) VALUES
            (1, 'Operador', 'Agente telefónico que realiza gestiones'),
            (2, 'Supervisor', 'Supervisa el trabajo de los operadores'),
            (3, 'Administrador', 'Acceso completo al sistema')
        """))

        # Estados de usuario
        connection.execute(text("""
            INSERT OR IGNORE INTO users_estados (id, nombre) VALUES
            (1, 'Activo'),
            (2, 'Inactivo'),
            (3, 'Suspendido')
        """))

        # Grupos de usuarios
        connection.execute(text("""
            INSERT OR IGNORE INTO users_grupos (id, nombre, descripcion) VALUES
            (1, 'Ventas', 'Equipo de ventas telefónicas'),
            (2, 'Retención', 'Equipo de retención de clientes'),
            (3, 'Cobranzas', 'Equipo de gestión de cobranzas')
        """))

        # Categorías de usuarios
        connection.execute(text("""
            INSERT OR IGNORE INTO users_categorias (id, categoria) VALUES
            (1, 'Junior'),
            (2, 'Senior'),
            (3, 'Team Leader')
        """))

        # Estados de contactos
        connection.execute(text("""
            INSERT OR IGNORE INTO contactos_estado (id, nombre) VALUES
            (1, 'Prospecto'),
            (2, 'Cliente'),
            (3, 'Rechazado'),
            (4, 'No contactar'),
            (5, 'Seguimiento')
        """))

        # Estados de campañas
        connection.execute(text("""
            INSERT OR IGNORE INTO campaigns_estados (id, nombre, descripcion) VALUES
            (1, 'Activa', 'Campaña en ejecución'),
            (2, 'Pausada', 'Campaña temporalmente suspendida'),
            (3, 'Finalizada', 'Campaña completada'),
            (4, 'Planificada', 'Campaña programada para el futuro')
        """))

        # Tipos de gestión
        connection.execute(text("""
            INSERT OR IGNORE INTO gestiones_tipo (id, nombre) VALUES
            (1, 'Llamada'),
            (2, 'Email'),
            (3, 'SMS'),
            (4, 'Visita'),
            (5, 'WhatsApp')
        """))

        # Resultados de gestión
        connection.execute(text("""
            INSERT OR IGNORE INTO gestiones_resultado (id, nombre) VALUES
            (1, 'Coordinado'),
            (2, 'Contactado'),
            (3, 'No contesta'),
            (4, 'Ocupado'),
            (5, 'Fuera de servicio'),
            (6, 'Número equivocado'),
            (7, 'Rechazado'),
            (8, 'Agendado'),
            (9, 'No interesado'),
            (10, 'Volver a llamar'),
            (11, 'Pendiente'),
            (12, 'Datos incorrectos'),
            (13, 'Menor de edad'),
            (14, 'Ya tiene el servicio'),
            (15, 'Coordinar por mail'),
            (16, 'Encuesta completada')
        """))

        # Usuarios de ejemplo
        connection.execute(text("""
            INSERT OR IGNORE INTO users (id, id_tipo, id_estado, id_grupo, id_categoria, ci, nombre, apellido, usuario, password, id_tipo_escala) VALUES
            (1, 1, 1, 1, 1, 12345678, 'Juan', 'Pérez', 'jperez', 'hash123', 1),
            (2, 1, 1, 1, 1, 23456789, 'María', 'González', 'mgonzalez', 'hash456', 1),
            (3, 1, 1, 1, 2, 34567890, 'Carlos', 'Rodríguez', 'crodriguez', 'hash789', 1),
            (4, 2, 1, 1, 3, 45678901, 'Ana', 'Martínez', 'amartinez', 'hashabc', 2),
            (5, 1, 1, 2, 2, 56789012, 'Pedro', 'López', 'plopez', 'hashdef', 1)
        """))

        # Campañas de ejemplo
        connection.execute(text("""
            INSERT OR IGNORE INTO campaigns (id, id_estado, codigo, nombre, descripcion, brokers, fc_inicio, fc_final) VALUES
            (1, 1, 'VENTA2025', 'Campaña Ventas Q1 2025', 'Campaña de ventas primer trimestre', '_1__2__3_', 20250101, 20250331),
            (2, 1, 'RETEN2025', 'Retención Clientes', 'Campaña de retención de clientes existentes', '_2__4__5_', 20250101, 20250630),
            (3, 1, 'CROSS2025', 'Cross Selling', 'Venta cruzada de productos adicionales', '_1__3__5_', 20250201, 20250430),
            (4, 2, 'COBRA2025', 'Cobranzas', 'Gestión de cobranzas morosas', '_4__5_', 20250101, 20251231),
            (5, 1, 'ENCUES25', 'Encuestas Satisfacción', 'Encuestas de satisfacción post-venta', '_1__2__3__4_', 20250115, 20250315)
        """))

        # Teléfonos de ejemplo
        connection.execute(text("""
            INSERT OR IGNORE INTO telefonos (id, tipo, numero) VALUES
            (1, 1, 24001234), (2, 2, 98765432), (3, 1, 24005678), (4, 2, 99123456),
            (5, 1, 24009012), (6, 2, 97456789), (7, 1, 24003456), (8, 2, 96789012),
            (9, 1, 24007890), (10, 2, 95123456), (11, 2, 94567890), (12, 2, 93456789),
            (13, 1, 24002345), (14, 1, 24006789), (15, 2, 92345678), (16, 2, 91234567),
            (17, 1, 24004567), (18, 1, 24008901), (19, 2, 90123456), (20, 2, 98901234)
        """))

        # Contactos de ejemplo
        connection.execute(text("""
            INSERT OR IGNORE INTO contactos (id, id_estado, id_domicilio, id_ocupacion, id_estado_civil, ci, nombre1, nombre2, apellido1, apellido2, fc_nacimiento, sexo, zurdo, id_tel_fijo1, id_tel_fijo2, id_tel_movil1, id_tel_movil2, email, id_userinsert, id_fuente_dato, se_queda, timestamp, mascota) VALUES
            (1, 1, 1, 1, 1, 11111111, 'Roberto', 'Carlos', 'Silva', 'Mendoza', 19850315, 'M', 'N', 1, 13, 2, 11, 'roberto.silva@email.com', 1, 1, 0, 20250101120000, 1),
            (2, 2, 2, 2, 2, 22222222, 'Laura', 'Isabel', 'Fernández', 'Castro', 19920708, 'F', 'N', 3, 14, 4, 12, 'laura.fernandez@email.com', 2, 1, 1, 20250102130000, 0),
            (3, 1, 3, 3, 1, 33333333, 'Miguel', 'Ángel', 'Torres', 'Vega', 19880422, 'M', 'S', 5, 17, 6, 15, 'miguel.torres@email.com', 1, 2, 0, 20250103140000, 1),
            (4, 1, 4, 1, 3, 44444444, 'Carmen', 'Rosa', 'Jiménez', 'Morales', 19750912, 'F', 'N', 7, 18, 8, 16, 'carmen.jimenez@email.com', 3, 1, 0, 20250104150000, 0),
            (5, 3, 5, 4, 1, 55555555, 'Andrés', 'Felipe', 'Vargas', 'Ruiz', 19901203, 'M', 'N', 9, 0, 10, 19, 'andres.vargas@email.com', 2, 3, 1, 20250105160000, 1),
            (6, 1, 6, 2, 2, 66666666, 'Patricia', 'Elena', 'Herrera', 'Díaz', 19860825, 'F', 'N', 0, 1, 20, 2, 'patricia.herrera@email.com', 4, 1, 0, 20250106170000, 0),
            (7, 2, 7, 5, 1, 77777777, 'Francisco', 'Javier', 'Ramírez', 'Cruz', 19820617, 'M', 'S', 3, 5, 4, 6, 'francisco.ramirez@email.com', 1, 2, 1, 20250107180000, 1),
            (8, 1, 8, 1, 4, 88888888, 'Beatriz', 'Alejandra', 'Guerrero', 'Peña', 19940210, 'F', 'N', 7, 9, 8, 10, 'beatriz.guerrero@email.com', 5, 1, 0, 20250108190000, 0),
            (9, 1, 9, 3, 1, 99999999, 'Jorge', 'Luis', 'Mendoza', 'Flores', 19870530, 'M', 'N', 13, 17, 11, 15, 'jorge.mendoza@email.com', 3, 2, 0, 20250109200000, 1),
            (10, 5, 10, 2, 2, 10101010, 'Valentina', 'Sofía', 'Ortega', 'Restrepo', 19910914, 'F', 'N', 14, 18, 12, 16, 'valentina.ortega@email.com', 2, 1, 1, 20250110210000, 0)
        """))

        # Gestiones de ejemplo (muestra representativa)
        connection.execute(text("""
            INSERT OR IGNORE INTO gestiones (id, id_tipo, id_campaign, id_broker, id_contacto, id_resultado, notas, timestamp, id_tel_fijo1) VALUES
            (1, 1, 1, 1, 1, 3, 'Primera llamada, no contesta', '20250115080000', 1),
            (2, 1, 1, 1, 1, 2, 'Contactado, muestra interés', '20250116090000', 1),
            (3, 1, 1, 1, 1, 1, 'Coordinada visita para el jueves', '20250117100000', 1),
            (4, 1, 1, 2, 1, 8, 'Reagendado para la próxima semana', '20250118110000', 2),
            (5, 1, 1, 2, 1, 1, 'Venta cerrada exitosamente', '20250119120000', 2),
            (6, 1, 2, 3, 2, 2, 'Cliente actual, consulta sobre renovación', '20250115130000', 3),
            (7, 1, 2, 3, 2, 1, 'Acepta renovación, coordinado pago', '20250116140000', 3),
            (8, 1, 2, 4, 2, 11, 'Pendiente documentación', '20250117150000', 4),
            (9, 1, 2, 4, 2, 1, 'Documentación completa, proceso finalizado', '20250118160000', 4),
            (10, 1, 3, 5, 3, 4, 'Línea ocupada', '20250115170000', 5),
            (11, 1, 3, 5, 3, 3, 'No contesta segunda llamada', '20250116180000', 5),
            (12, 1, 3, 1, 3, 2, 'Contactado, interesado en producto', '20250117190000', 6),
            (13, 1, 3, 1, 3, 8, 'Agendado para presentación', '20250118200000', 6),
            (14, 1, 3, 2, 3, 1, 'Presentación realizada, coordinado', '20250119210000', 6),
            (15, 1, 1, 3, 4, 7, 'No está interesada en el momento', '20250115220000', 7),
            (16, 1, 1, 3, 4, 10, 'Solicita llamar en 2 semanas', '20250130080000', 7),
            (17, 1, 1, 4, 4, 2, 'Segunda oportunidad, muestra interés', '20250201090000', 8),
            (18, 1, 1, 4, 4, 1, 'Acepta propuesta, coordinado', '20250202100000', 8),
            (19, 1, 4, 5, 5, 9, 'Cliente rechaza gestión de cobranza', '20250115110000', 9),
            (20, 1, 4, 5, 5, 12, 'Datos de contacto incorrectos', '20250116120000', 10),
            (21, 1, 4, 1, 5, 2, 'Actualización de datos, contactado', '20250117130000', 10),
            (22, 1, 4, 1, 5, 11, 'Pendiente regularizar situación', '20250118140000', 10),
            (23, 1, 5, 2, 6, 16, 'Encuesta de satisfacción completada', '20250115150000', 1),
            (24, 1, 1, 2, 6, 2, 'Cross selling, consultó otros productos', '20250116160000', 20),
            (25, 1, 1, 3, 6, 8, 'Interesada, agendada nueva llamada', '20250117170000', 20),
            (26, 1, 1, 3, 6, 1, 'Adquiere producto adicional', '20250118180000', 20),
            (27, 1, 2, 4, 7, 2, 'Cliente fidelizado, consulta beneficios', '20250115190000', 3),
            (28, 1, 2, 4, 7, 1, 'Acepta upgrade del servicio', '20250116200000', 3),
            (29, 1, 2, 5, 7, 11, 'Pendiente activación técnica', '20250117210000', 4),
            (30, 1, 2, 5, 7, 1, 'Servicio activado correctamente', '20250118220000', 4),
            (31, 1, 3, 1, 8, 13, 'Menor de edad, no puede contratar', '20250115230000', 7),
            (32, 1, 3, 1, 8, 2, 'Habló con tutor, autoriza gestión', '20250120080000', 8),
            (33, 1, 3, 2, 8, 15, 'Coordinación vía email con tutor', '20250121090000', 8),
            (34, 1, 3, 2, 8, 1, 'Contrato firmado por tutor', '20250122100000', 8),
            (35, 1, 1, 3, 9, 6, 'Número equivocado', '20250115110000', 13),
            (36, 1, 1, 3, 9, 2, 'Número correcto, contactado', '20250116120000', 11),
            (37, 1, 1, 4, 9, 14, 'Ya tiene servicio similar con competencia', '20250117130000', 11),
            (38, 1, 1, 4, 9, 10, 'Solicita llamar cuando venza contrato', '20250118140000', 11),
            (39, 1, 5, 5, 10, 16, 'Encuesta completada, muy satisfecha', '20250115150000', 14),
            (40, 1, 2, 5, 10, 2, 'Consulta sobre nuevos servicios', '20250116160000', 12),
            (41, 1, 2, 1, 10, 1, 'Contrata servicio adicional', '20250117170000', 12)
        """))

        connection.commit()
        print("Base de datos inicializada correctamente!")

if __name__ == "__main__":
    init_database()