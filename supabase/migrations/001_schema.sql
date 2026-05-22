-- Kilomètre-Santé — Schéma Supabase
-- Exécuter dans SQL Editor du dashboard Supabase

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS pharmacies (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  legacy_id TEXT UNIQUE,
  name TEXT NOT NULL,
  arrondissement TEXT NOT NULL,
  quartier TEXT NOT NULL,
  phone TEXT NOT NULL,
  hours TEXT NOT NULL DEFAULT '',
  is_on_duty BOOLEAN NOT NULL DEFAULT false,
  image_url TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS products (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  pharmacy_id UUID NOT NULL REFERENCES pharmacies(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  price_fcfa INTEGER NOT NULL DEFAULT 0,
  category TEXT NOT NULL DEFAULT 'Général',
  image_url TEXT,
  in_stock BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_pharmacies_arrondissement ON pharmacies(arrondissement);
CREATE INDEX IF NOT EXISTS idx_pharmacies_on_duty ON pharmacies(is_on_duty);
CREATE INDEX IF NOT EXISTS idx_products_pharmacy ON products(pharmacy_id);

ALTER TABLE pharmacies ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "pharmacies_select_public" ON pharmacies;
CREATE POLICY "pharmacies_select_public" ON pharmacies
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "pharmacies_insert_auth" ON pharmacies;
CREATE POLICY "pharmacies_insert_auth" ON pharmacies
  FOR INSERT TO authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "pharmacies_update_auth" ON pharmacies;
CREATE POLICY "pharmacies_update_auth" ON pharmacies
  FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "pharmacies_delete_auth" ON pharmacies;
CREATE POLICY "pharmacies_delete_auth" ON pharmacies
  FOR DELETE TO authenticated USING (true);

DROP POLICY IF EXISTS "products_select_public" ON products;
CREATE POLICY "products_select_public" ON products
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "products_insert_auth" ON products;
CREATE POLICY "products_insert_auth" ON products
  FOR INSERT TO authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "products_update_auth" ON products;
CREATE POLICY "products_update_auth" ON products
  FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "products_delete_auth" ON products;
CREATE POLICY "products_delete_auth" ON products
  FOR DELETE TO authenticated USING (true);

-- Storage buckets (créer aussi via Dashboard si besoin)
INSERT INTO storage.buckets (id, name, public)
VALUES ('pharmacy-images', 'pharmacy-images', true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.buckets (id, name, public)
VALUES ('product-images', 'product-images', true)
ON CONFLICT (id) DO NOTHING;

DROP POLICY IF EXISTS "pharmacy_images_public_read" ON storage.objects;
CREATE POLICY "pharmacy_images_public_read" ON storage.objects
  FOR SELECT USING (bucket_id = 'pharmacy-images');

DROP POLICY IF EXISTS "product_images_public_read" ON storage.objects;
CREATE POLICY "product_images_public_read" ON storage.objects
  FOR SELECT USING (bucket_id = 'product-images');

DROP POLICY IF EXISTS "pharmacy_images_auth_upload" ON storage.objects;
CREATE POLICY "pharmacy_images_auth_upload" ON storage.objects
  FOR INSERT TO authenticated WITH CHECK (bucket_id = 'pharmacy-images');

DROP POLICY IF EXISTS "product_images_auth_upload" ON storage.objects;
CREATE POLICY "product_images_auth_upload" ON storage.objects
  FOR INSERT TO authenticated WITH CHECK (bucket_id = 'product-images');

DROP POLICY IF EXISTS "pharmacy_images_auth_update" ON storage.objects;
CREATE POLICY "pharmacy_images_auth_update" ON storage.objects
  FOR UPDATE TO authenticated USING (bucket_id = 'pharmacy-images');

DROP POLICY IF EXISTS "product_images_auth_update" ON storage.objects;
CREATE POLICY "product_images_auth_update" ON storage.objects
  FOR UPDATE TO authenticated USING (bucket_id = 'product-images');
