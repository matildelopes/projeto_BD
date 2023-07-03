-- IC-1: Nenhum empregado pode ter menos de 18 anos de idade:
DROP TRIGGER IF EXISTS ic_1_trigger on employee;

CREATE OR REPLACE FUNCTION ic_1() RETURNS trigger AS $$
BEGIN
    IF DATE_TRUNC('year', age(NEW.bdate)) < INTERVAL 18 THEN
        RAISE EXCEPTION 'A idade do empregado deve ser igual ou superior a 18 anos.';
    END IF;

    RETURN NEW;
END$$ LANGUAGE plpgsql;

CREATE TRIGGER ic_1_trigger
    BEFORE INSERT OR UPDATE ON employee
    FOR EACH ROW
    EXECUTE FUNCTION ic_1();



-- IC-2: Um 'Workplace' é obrigatoriamente um 'Office' ou 'Warehouse', mas não pode ser ambos.

DROP TRIGGER IF EXISTS ic_2_trigger on workplace;

CREATE OR REPLACE FUNCTION ic_2() RETURNS trigger AS $$
BEGIN
    IF (NEW.address IN (SELECT address FROM office)) AND (NEW.address IN (SELECT address FROM warehouse)) THEN
        RAISE EXCEPTION 'Um Workplace não pode ser simultaneamente um Office e um Warehouse.';
    END IF;
    RETURN NEW;
END$$ LANGUAGE plpgsql;

CREATE TRIGGER ic_2_trigger
    BEFORE INSERT OR UPDATE ON workplace
    FOR EACH ROW
    EXECUTE FUNCTION ic_2();



--IC3: Uma 'Order' tem de figurar obrigatoriamente em 'Contains'.

DROP TRIGGER IF EXISTS ic_3_trigger on orders;

CREATE OR REPLACE FUNCTION ic_3() RETURNS trigger AS $$
BEGIN
    IF NEW.order_no NOT IN (SELECT order_no FROM contains) THEN
        RAISE EXCEPTION 'A ordem não consta na tabela "contains".';
    END IF;

    RETURN NEW;
END$$ LANGUAGE plpgsql;

CREATE TRIGGER ic_3_trigger
    BEFORE INSERT ON orders
    FOR EACH ROW
    EXECUTE FUNCTION ic_3();