-- Seed minimal — pour le jeu complet (45 produits x 18 pharmacies),
-- importer data/seed-pharmacies.json via le dashboard ou regenerer:
--   powershell -File scripts/generate-seed.ps1

-- Exemple: 3 pharmacies (complet dans seed-pharmacies.json)
-- Voir migrations/001_schema.sql avant ce fichier.

TRUNCATE products, pharmacies CASCADE;

INSERT INTO pharmacies (legacy_id, name, arrondissement, quartier, phone, hours, is_on_duty, image_url) VALUES
('ph-001', 'Pharmacie de la Poste', '1er Arrondissement', 'Centre-ville', '+242 06 512 34 01', 'Lun-Sam 8h-20h | Dim 9h-13h', true, 'https://images.unsplash.com/photo-1587854692152-c3f853d51358?w=600&h=360&fit=crop');

-- Pour Supabase production: utiliser l''API ou un import CSV genere depuis seed-pharmacies.json
