function load_env
    if test (count $argv) -eq 0
        echo "Uso: fish_load_env <arquivo .env>"
        return 1
    end

    set filename $argv[1]

    if not test -f $filename
        echo "Arquivo não encontrado: $filename"
        return 1
    end

    for line in (cat $filename)
        # Pular linhas vazias ou comentários
        if string match -qr '^\s*#' -- $line
            continue
        end

        if string match -qr '^\s*$' -- $line
            continue
        end

        # Extrair chave e valor
        set parts (string split -m 1 = $line)
        set key (string trim $parts[1])
        set value (string trim --chars=\" $parts[2]) # remove aspas ao redor

        # Definir variável global exportada
        set -gx $key $value
    end
end
