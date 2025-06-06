shader_type canvas_item;

uniform float speed = 0.5;         // velocidade vertical dos feixes
uniform float density = 12.0;      // quantidade de feixes
uniform float thickness = 0.03;    // largura dos feixes
uniform vec4 color : source_color = vec4(1.0, 1.0, 1.0, 0.08); // cor e opacidade

void fragment() {
    vec2 uv = UV;

    // Movimento vertical usando fract para evitar artefatos
    float y = fract(uv.y + TIME * speed);

    float line = 0.0;

    // Ajuste para pixel art: feixes alinhados a linhas horizontais "pixeladas"
    for (float i = 0.0; i < 1.0; i += 1.0 / density) {
        // Pequeno deslocamento horizontal baseado no índice para evitar linhas duplicadas
        float offsetX = mod(i * 7.0, 1.0);

        // Distância horizontal ao centro do feixe (com offset)
        float dist = abs(uv.x - (i + offsetX * 0.03));

        // Linhas nítidas (mais "pixeladas") com smoothstep invertido
        line += smoothstep(thickness, thickness * 0.6, dist);
    }

    // Inverter line para que seja 1 no centro da linha e 0 fora
    line = 1.0 - clamp(line, 0.0, 1.0);

    COLOR = color * line;
}
