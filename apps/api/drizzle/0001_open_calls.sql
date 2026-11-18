CREATE TYPE "public"."notification_type" AS ENUM('application_received', 'application_status', 'new_follower');--> statement-breakpoint
CREATE TYPE "public"."promotion_placement" AS ENUM('opportunities_feed');--> statement-breakpoint
CREATE TYPE "public"."report_reason" AS ENUM('scam', 'harassment', 'inappropriate', 'spam', 'underage', 'other');--> statement-breakpoint
CREATE TYPE "public"."report_status" AS ENUM('open', 'resolved');--> statement-breakpoint
CREATE TYPE "public"."report_target" AS ENUM('user', 'opportunity', 'portfolio_item');--> statement-breakpoint
CREATE TYPE "public"."application_status" AS ENUM('submitted', 'shortlisted', 'declined', 'hired');--> statement-breakpoint
CREATE TYPE "public"."compensation_type" AS ENUM('paid', 'unpaid', 'negotiable');--> statement-breakpoint
CREATE TYPE "public"."opportunity_status" AS ENUM('open', 'closed', 'removed');--> statement-breakpoint
CREATE TYPE "public"."portfolio_platform" AS ENUM('youtube', 'tiktok', 'instagram', 'facebook', 'audiomack', 'boomplay', 'soundcloud', 'spotify', 'other');--> statement-breakpoint
CREATE TABLE "notifications" (
	"id" uuid PRIMARY KEY NOT NULL,
	"user_id" uuid NOT NULL,
	"type" "notification_type" NOT NULL,
	"actor_id" uuid,
	"opportunity_id" uuid,
	"application_id" uuid,
	"read_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "promotions" (
	"id" uuid PRIMARY KEY NOT NULL,
	"sponsor_name" varchar(60) NOT NULL,
	"title" varchar(80) NOT NULL,
	"body" varchar(200) NOT NULL,
	"cta_label" varchar(30) NOT NULL,
	"url" text NOT NULL,
	"placement" "promotion_placement" NOT NULL,
	"starts_at" timestamp with time zone NOT NULL,
	"ends_at" timestamp with time zone NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "reports" (
	"id" uuid PRIMARY KEY NOT NULL,
	"reporter_id" uuid NOT NULL,
	"target_type" "report_target" NOT NULL,
	"target_id" uuid NOT NULL,
	"reason" "report_reason" NOT NULL,
	"details" varchar(500),
	"status" "report_status" DEFAULT 'open' NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "applications" (
	"id" uuid PRIMARY KEY NOT NULL,
	"opportunity_id" uuid NOT NULL,
	"applicant_id" uuid NOT NULL,
	"message" varchar(1000) NOT NULL,
	"portfolio_item_id" uuid,
	"status" "application_status" DEFAULT 'submitted' NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "opportunities" (
	"id" uuid PRIMARY KEY NOT NULL,
	"poster_id" uuid NOT NULL,
	"title" varchar(100) NOT NULL,
	"description" varchar(2000) NOT NULL,
	"category_id" uuid NOT NULL,
	"city" varchar(80) NOT NULL,
	"country" char(2) NOT NULL,
	"compensation" "compensation_type" NOT NULL,
	"budget_amount" integer,
	"currency" char(3) DEFAULT 'XAF' NOT NULL,
	"deadline" date,
	"status" "opportunity_status" DEFAULT 'open' NOT NULL,
	"featured_until" timestamp with time zone,
	"applications_count" integer DEFAULT 0 NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "portfolio_items" (
	"id" uuid PRIMARY KEY NOT NULL,
	"user_id" uuid NOT NULL,
	"title" varchar(80) NOT NULL,
	"description" varchar(500),
	"url" text NOT NULL,
	"platform" "portfolio_platform" NOT NULL,
	"category_id" uuid,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_actor_id_users_id_fk" FOREIGN KEY ("actor_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_opportunity_id_opportunities_id_fk" FOREIGN KEY ("opportunity_id") REFERENCES "public"."opportunities"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_application_id_applications_id_fk" FOREIGN KEY ("application_id") REFERENCES "public"."applications"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "reports" ADD CONSTRAINT "reports_reporter_id_users_id_fk" FOREIGN KEY ("reporter_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "applications" ADD CONSTRAINT "applications_opportunity_id_opportunities_id_fk" FOREIGN KEY ("opportunity_id") REFERENCES "public"."opportunities"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "applications" ADD CONSTRAINT "applications_applicant_id_users_id_fk" FOREIGN KEY ("applicant_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "applications" ADD CONSTRAINT "applications_portfolio_item_id_portfolio_items_id_fk" FOREIGN KEY ("portfolio_item_id") REFERENCES "public"."portfolio_items"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "opportunities" ADD CONSTRAINT "opportunities_poster_id_users_id_fk" FOREIGN KEY ("poster_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "opportunities" ADD CONSTRAINT "opportunities_category_id_talent_categories_id_fk" FOREIGN KEY ("category_id") REFERENCES "public"."talent_categories"("id") ON DELETE restrict ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "portfolio_items" ADD CONSTRAINT "portfolio_items_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "portfolio_items" ADD CONSTRAINT "portfolio_items_category_id_talent_categories_id_fk" FOREIGN KEY ("category_id") REFERENCES "public"."talent_categories"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "notifications_user_idx" ON "notifications" USING btree ("user_id","created_at");--> statement-breakpoint
CREATE INDEX "promotions_active_idx" ON "promotions" USING btree ("placement","starts_at","ends_at");--> statement-breakpoint
CREATE UNIQUE INDEX "reports_once_per_reporter_key" ON "reports" USING btree ("reporter_id","target_type","target_id");--> statement-breakpoint
CREATE INDEX "reports_queue_idx" ON "reports" USING btree ("status","created_at");--> statement-breakpoint
CREATE UNIQUE INDEX "applications_one_per_person_key" ON "applications" USING btree ("opportunity_id","applicant_id");--> statement-breakpoint
CREATE INDEX "applications_applicant_idx" ON "applications" USING btree ("applicant_id","created_at");--> statement-breakpoint
CREATE INDEX "opportunities_feed_idx" ON "opportunities" USING btree ("status","created_at");--> statement-breakpoint
CREATE INDEX "opportunities_poster_idx" ON "opportunities" USING btree ("poster_id");--> statement-breakpoint
CREATE INDEX "opportunities_category_idx" ON "opportunities" USING btree ("category_id");--> statement-breakpoint
CREATE INDEX "portfolio_items_user_idx" ON "portfolio_items" USING btree ("user_id","created_at");